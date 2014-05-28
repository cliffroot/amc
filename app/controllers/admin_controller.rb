class AdminController < ApplicationController
  def home
  	@distributors = Distributor.all
  	@distributorsCount = Distributor.count
  	@productsCount = Product.count
  end

  def help
  end
end
