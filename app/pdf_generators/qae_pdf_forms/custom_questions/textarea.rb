module QaePdfForms::CustomQuestions::Textarea

  MAIN_CONTENT_BLOCKS = ["p", "ul", "ol"]

  SUPPORTED_TAGS = MAIN_CONTENT_BLOCKS + ["li", "a", "em", "strong", "text"]

  def render_wysywyg_content
    if display_wysywyg_q?
      wysywyg_entries.each do |child|
        tag_name = wysywyg_get_tag_name(child)

        if MAIN_CONTENT_BLOCKS.include?(tag_name)
          render_wysywyg_line(
            {
              "<" + tag_name + ">" => {
                style: wysywyg_get_style(child),
                content: wysywyg_get_item_content(child)
              }
            }
          )
        end
      end
    end
  end

  private

  def display_wysywyg_q?
    q_visible? && humanized_answer.present?
  end

  def wysywyg_entries
    Nokogiri::HTML.parse(
      humanized_answer
    ).children[1]
     .children[0]
     .children
  end

  def render_wysywyg_line(line)
    if line.keys[0] == "<p>"
      lines_style = styles_picker(get_styles(line).split(", "))
      print_pdf(get_content(line).join(""), lines_style)

    elsif line.keys[0] == "<ul>" || line.keys[0] == "<ol>"
      print_lists(line.keys[0], line)
    end
  end

  def print_lists(key, line)
    lists_style = get_styles(line)
    content = get_content(line)

    content.map! do |el|
      if el.include?("\r\n")
        element = el.gsub!("\r", "").gsub!("\n", "").gsub!("\t", "")
      end
      el
    end.reject!(&:blank?)

    content << "\r\n\t"
    string = []
    styles = []

    if lists_style.present?
      margin_left = lists_style.split(", ").select do |el|
        el.include?("margin-left")
      end.map! do |el|
        el.split(":").second.strip.gsub!("px", "").to_i/2
      end.sum

      styles << "margin-left:#{margin_left}px"
    end

    strings_picker(content, string, styles, key)
  end

  def strings_picker(content, string, styles, key)
    n = 0
    keys_history = [key]
    ns_history = [n]
    li_counter = 0

    content.each do |i|
      if i.is_a?(Hash) && i.keys[0] == "<li>"

        if key == "<ol>"
          n += 1
        end

        if string.present?
          li_style = styles_picker(styles)
          print_pdf(string.join(""), li_style)

          if li_counter > 1
            (li_counter - 1).times do
              styles.pop
            end
            li_counter = 0
          else
            li_counter = 0
          end

          string = []
          marker_of_list(string, key, n)

          if get_styles(i).present?
            styles << get_styles(i)
          end
        else
          marker_of_list(string, key, n)

          if get_styles(i).present?
            styles << get_styles(i)
          end
        end

      elsif i.is_a?(Hash) && i.keys[0] == "<ul>"
        li_style = styles_picker(styles)
        print_pdf(string.join(""), li_style)

        key = "<ul>"
        keys_history << key
        ns_history << n
        string = []

        if get_styles(i).present?
          styles << get_styles(i)
        else
          styles << "margin-left: 20px"
        end

      elsif i.is_a?(Hash) && i.keys[0] == "<ol>"
        li_style = styles_picker(styles)
        print_pdf(string.join(""), li_style)

        ns_history << n
        n = 0
        key = "<ol>"
        keys_history << key
        string = []

        if get_styles(i).present?
          styles << get_styles(i)
        else
          styles << "margin-left: 20px"
        end

      elsif i == "</ul>" || i == "</ol>"
        keys_history.pop
        key = keys_history.last
        n = ns_history.last
        ns_history.pop

      elsif i == "</li>"
        li_counter += 1

      elsif i == content.last
        li_style = styles_picker(styles)
        print_pdf(string.join(""), li_style)

      else
        string << i
      end
    end
  end

  def marker_of_list(string, key, n)
    if key == "<ul>"
      string << "• "
    else
      string << "#{n}. "
    end
  end

  def get_styles(line)
    line.values[0][:style].to_s
  end

  def get_content(line)
    line.values[0][:content]
  end

  def print_pdf(line, lines_style)
    form_pdf.indent 7.mm do
      if line.present?
        form_pdf.font("Times-Roman") do
          form_pdf.text "#{line}", lines_style if lines_style.present?
        end
      end
    end
  end

  def styles_picker(arr)
    styles = { inline_format: true,
                       color: FormPdf::DEFAULT_ANSWER_COLOR }
    if arr.present?
      margin_list = arr.select do |el|
        el.include?("margin-left")
      end.map! do |el|
        el.split(":").second.strip.gsub!("px", "").to_i
      end

      styles[:indent_paragraphs] = margin_list.sum

      arr.select do |el|
        el.include?("text-align")
      end.uniq.map! do |el|
        styles[:align] = el.split(":").second.strip.to_sym
      end
    end
    styles
  end

  def wysywyg_get_tag_name(tag)
    if tag.name.is_a?(String) && SUPPORTED_TAGS.detect do |el|
        el == tag.name
      end

      tag.name
    end
  end

  def wysywyg_get_style(tag)
    get_attribute_value(tag, "style")
  end

  def links_href(tag)
    get_attribute_value(tag, "href")
  end

  def get_attribute_value(tag, attr_name)
    tag.attributes[attr_name].value if tag.attributes[attr_name].present?
  end

  def simple_text(tag)
    if tag.xpath('text()').present?
      tag.xpath('text()').text
    end
  end

  def wysywyg_get_item_content(child)
    content = []

    if child.children.present?
      child.children.each do |baby|
        tag = wysywyg_get_tag_name(baby)

        if tag == SUPPORTED_TAGS[1] || tag == SUPPORTED_TAGS[2]
          content << {"<" + tag + ">" => {style: wysywyg_get_style(baby)}}
        elsif tag == SUPPORTED_TAGS[3]
          content << {"<" + tag + ">" => {style: wysywyg_get_style(baby)}}
        elsif tag == SUPPORTED_TAGS[4]
          tag = "link"
          content << "<u><" + tag + " href=#{links_href(baby)}>"
        elsif tag == SUPPORTED_TAGS[7]
          simple_text = baby.text
          content << simple_text
        else
          content << "<" + tag + ">"
        end

        wysywyg_get_item_content(baby)

        if tag != SUPPORTED_TAGS[7]
          if tag == "link"
            content << "</" + tag + "></u>"
          else
            content << "</" + tag + ">"
          end
        end
      end
    end

    content
  end
end
