module AfterSignupHelper
  def countries
    Country.all.order('name ASC')
  end
end
