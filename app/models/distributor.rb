# encoding: utf-8
class Distributor < ActiveRecord::Base
	attr_accessible :column_amount, :column_code, :column_description, :column_koef, :column_price, :column_weight, :formula_del_eu, :formula_del_uae, :formula_price, :name, :column_pg
	before_destroy do
		Manufacturer.destroy_all("distributor_id = " + id.to_s)
	end
	before_create :createVarsAndFormulas


	def createVarsAndFormulas
		createVar('usd', '8.3')
		createVar('k1', '1.10')
		createVar('k2', '1.2')
		createVar('k3', '1.15')
		createVar('k4', '7')
		self.formula_price = (self.formula_price != "" ? self.formula_price : "цена * k1 * usd * k2")
		self.formula_del_uae = (self.formula_del_uae  != "" ? self.formula_del_uae : 'вес * usd * k3 * k2 * k4')
	end

	def createVars
		   
	end

		def createVar(name, value)
			if !Var.find(:first, :conditions => [ "name = ?", name] )
				Var.create(:name => name, :value => value)
			end
		end
end
