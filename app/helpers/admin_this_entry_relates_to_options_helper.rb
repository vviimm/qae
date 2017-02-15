module AdminThisEntryRelatesToOptionsHelper

  DATA = [{"products" => "Products"},
          {"services" => "Services"},
          {"product" => "A product"},
          {"service" => "A service"},
          {"business_model" => "A business model"},
          {"management_approach" => "A management approach"},
          {"mentoring" => "A programme which provides careers advice, skills development or mentoring that prepare young people for the world of work and/or accessible structured work experience."},
          {"career_opportunities_accessibility" => "A programme which makes career opportunities more accessible by offering non-graduate routes such as traineeships, apprenticeships or internships, or by reforming recruitment practices."},
          {"workplace_fostering" => "A programme which fosters workplaces where employees have equal access to ongoing support and progression opportunities to further their careers."}]

  def options_available(options)
    @check_options = DATA.select{ |i| options.include?(i.keys.first) }.map{ |el| [el.keys.first, el.values.first] }
  end
end

