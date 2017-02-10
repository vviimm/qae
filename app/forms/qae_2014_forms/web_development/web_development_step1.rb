class QAE2014Forms
  class << self
    def web_step1
      @web_step1 ||= proc do
        stars :teamwork_raiting, "Please rate on a five-point scale teamwork in your company" do
          required
          ref "A 1"
        end

        autocomplete :list_of_programming_languages, "Select programming languages you use in your company" do
          ref "A 2"
          required
          context %(
            <p>Select all that apply.</p>
          )
          tags [
            "ActionScript",
            "AppleScript",
            "Asp",
            "BASIC",
            "C",
            "C++",
            "Clojure",
            "COBOL",
            "ColdFusion",
            "Erlang",
            "Fortran",
            "Groovy",
            "Haskell",
            "Java",
            "JavaScript",
            "Lisp",
            "Perl",
            "PHP",
            "Python",
            "Ruby",
            "Scala",
            "Scheme"
          ]
        end

        slider :range_of_prices, "Select minimum and maxium price of projects for last 3 years" do
          ref "A 3"
          required
          min 10000
          max 100000
        end
      end
    end
  end
end
