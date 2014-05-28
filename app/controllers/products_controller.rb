#!/bin/env ruby
# encoding: utf-8
class ProductsController < ApplicationController

  def download 
    send_file Rails.root.join('public','export','exp.xls')
  end

  def index
  @products = Product.search(params[:search])
  @search_query = params[:search]

  require 'spreadsheet' #create xls file on windows machines 
  Spreadsheet.client_encoding = 'windows-1251'
  book = Spreadsheet::Workbook.new
  sheet1 = book.create_worksheet :name => 'Лист 1'
  row = sheet1.row(0)
  row.push 'Код'.encode('windows-1251'), 'Произв.'.encode('windows-1251'), 'Описание'.encode('windows-1251'), 'В валюте'.encode('windows-1251'), 
          'Доставка'.encode('windows-1251'), 'Общая цена'.encode('windows-1251'), 'Вес'.encode('windows-1251'), 'Кол.'.encode('windows-1251'), 
          'Напр.'.encode('windows-1251'), 'Постав.'.encode('windows-1251'), 'Дата'.encode('windows-1251')
  i = 1
  @products.each do |productlist|
    productlist.each do |product|
      if (product.id <= -1)
        next
      end
      row = sheet1.row(i) 
      price = getPrice(product) # collect the price. do all substitutions needed and returns it
      delivery_price = getDeliveryPrice(product) # multiplied by delievery
      dist = Distributor.where(:id => product.distributor_id).first
      # adds everything needed to an .xls file 
      row.push product.code
      row.push Manufacturer.find(product.manufacturer_id).name
      row.push product.description
      row.push "%.2f" % (product.price).gsub(',','.')
      row.push "%.2f" % delivery_price
      row.push "%.2f" % (price + delivery_price) 
      row.push product.weight 
      row.push product.amount 
      row.push product.route 
      row.push dist.name 
      row.push Manufacturer.find(product.manufacturer_id).last_price_update.strftime("%Y-%m-%d")
      i += 1
    end
    book.write Rails.root.join('public','export','exp.xls')
  end
  respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @products }
      end
  end

  def getPrice(product)
    dist = Distributor.where(:id => product.distributor_id).first
    price = dist.formula_price
    #replacing some common variables every formula should have 
    if dist.formula_price 
      if toup(price).index('ЦЕНА') 
        price = toup(price).gsub("ЦЕНА",product.price) 
      end
      if toup(price).index('ВЕС') 
        price = toup(price).gsub("ВЕС",product.weight) 
      end
      # for all the variables perform the substitution 
      Var.all.each do |var| 
        price = toup(price).gsub(toup(var.name.to_s),var.value.to_s)
      end
      price.gsub!(",",".") # just a client's wish
    end
    if price == nil # something has gone wrong 
      price = '0'
    end
    price = eval(price) # eval what we got 
    if !price 
      price = 0.0
    end   
    return price
  end

  def getDeliveryPrice(product) # the same thing as for getPrice 
    dist = Distributor.where(:id => product.distributor_id).first
    delivery_price = product.route == "EU" ? dist.formula_del_eu : dist.formula_del_uae
    puts delivery_price
    if delivery_price
      if toup(delivery_price).index('ВЕС') 
        delivery_price = toup(delivery_price).gsub("ВЕС",product.weight)
      end
      if toup(delivery_price).index('ЦЕНА') 
        delivery_price = toup(delivery_price).gsub("ЦЕНА",product.price)
      end
      Var.all.each do |var| 
        delivery_price = toup(delivery_price).gsub(toup(var.name.to_s),var.value.to_s) 
      end
      delivery_price.gsub!(",",".") 
    end
    if delivery_price == nil 
      delivery_price = '0'
    end 
    puts delivery_price
    delivery_price = eval(delivery_price) 
    if !delivery_price 
      delivery_price = 0.0  
    end
    return delivery_price
  end


  # POST /products
  # POST /products.json
  def create
    if (params[:file])
      #loaded file
      uploaded_io = params[:file]

      #get file extension
      dot_index = uploaded_io.original_filename.rindex('.')
      extension = dot_index ? uploaded_io.original_filename[dot_index + 1, 4] : ""

      # result is shown in the view 
      output = ""

      #the last id of the product in the base. needed for importing csv directly into db
      last_free_id = 1
      if Product.last
        last_free_id = Product.last.id + 1
      end
      
      if validExtension(extension)
        pathToDownFile = saveFile(uploaded_io)

        #all the extensions we allow. perhaps worth adding .txt here? 

        if extension == 'xls' || extension == 'xlsx'
            convert_to_csv(pathToDownFile)
            output, last_free_id = addData(pathToDownFile, last_free_id)

        elsif extension == 'csv'
            output, last_free_id = addData(pathToDownFile, last_free_id)

        elsif extension == 'zip'
            unzip(pathToDownFile)

            files = Dir.glob(Rails.root.join('public', 'uploads', 'unpacked', '*.csv').to_s)
            for file_path in files
              msg, last_free_id = addData(file_path, last_free_id)
              File.delete(file_path)
              output += msg
            end

            files = Dir.glob(Rails.root.join('public', 'uploads', 'unpacked', '*.xls*').to_s)
            for file_path in files
              absolutePath = convert_to_csv(file_path)
              msg, last_free_id = addData(absolutePath, last_free_id)
              File.delete(file_path)
              output += msg 
            end

            files = Dir.glob(Rails.root.join('public', 'uploads', 'unpacked', '*.txt').to_s)
            for file_path in files
              absolutePath = file_path #convert_to_csv(file_path)
              msg, last_free_id = addData(absolutePath, last_free_id)
              File.delete(file_path)
              output += msg 
            end
        end

        File.delete(pathToDownFile)
      else
        output = "<span class='red'>Ошибка. Загрузите файл в формате xls, xlsx, csv, zip</span>"
      end
      respond_to do |format|
        format.html { redirect_to '/admin/home', notice: output.html_safe}
      end
    end
  end

  def validExtension(extension)
   return extension == 'xls' || extension == 'xlsx' || extension == 'csv' || extension == 'zip' || extension == 'txt'
  end

  def saveFile(uploaded_io)
      absolutePath = Rails.root.join('public', 'uploads', uploaded_io.original_filename).to_s
      file = File.open(absolutePath, 'wb')
      file << uploaded_io.read
      file.close
      return absolutePath
  end

  def reorganize_csv(absolutePath, last_free_id, fileName, m_id) #here all the magic comes  
      manufacturer = Manufacturer.find(m_id)
      distributor = Distributor.find(params[:distributor][:id])
      route = params[:route][:id]
      headers = params[:headers] ? '1' : '0'
      column = Array.new
      column = getIndexes(distributor)
      path_to_proj = Rails.root.to_s
      path_to_db = path_to_proj + '/db'
      path_to_uploads = path_to_proj + '/public/uploads'
      #calling c++ program to reorganize csv the way we need 
      queryReorganizeCsv = path_to_uploads + '/reorganize_csv "' + absolutePath + '" "' + absolutePath + '.converted" ' + last_free_id.to_s + ' ' + headers + ' ' + m_id.to_s + ' ' + distributor.id.to_s + ' ' + route + ' ' + column[0].to_s + ' ' + column[1].to_s  + ' ' + column[2].to_s  + ' ' + column[3].to_s  + ' ' + column[4].to_s + ' ' + column[5].to_s
      
      # print queryReorganizeCsv
      prev_last_id = last_free_id

      #launch c++ program for reorganizing csv. it returns number of lines in a file
      last_free_id = `#{queryReorganizeCsv}`

      #if program craches 
      begin
        Integer(last_free_id)
      rescue
        last_free_id = prev_last_id
      end
                     
      # define the separator for the database 
      system("echo .separator '\|' > "+ path_to_db + '/csv_add')
      # import processed csv into database 
      system('echo .import \"' + absolutePath + '.converted\" products >> ' + path_to_db + '/csv_add')
      system ('cat ' + path_to_db + '/csv_add | sqlite3 ' + path_to_db + '/' + Rails.env + '.sqlite3 2> ' + path_to_proj + '/errors.log')
      File.delete(absolutePath + '.converted')
      file = File.open(path_to_proj + '/errors.log', 'r')
      size = file.size
      file.close
      if size == 0
        manufacturer.update_attributes(:last_price_update => Time.now)
        msg = '<span class="green">' +  fileName + " успешно загружен в БД</span>"
      else
        msg = "<span class='red'>Произошла ошибка при попытке загрузки " + fileName + " в БД</span>"
      end
      return msg, last_free_id
  end

  def getIndexes(distributor)
    result = Array.new
    result.push(distributor.column_code ? distributor.column_code - 1 : nil)
    result.push(distributor.column_price ? distributor.column_price - 1 : nil)
    result.push(distributor.column_weight ? distributor.column_weight - 1 : nil)
    result.push(distributor.column_amount ? distributor.column_amount - 1 : nil)
    result.push(distributor.column_description ? distributor.column_description - 1 : nil)
    result.push(distributor.column_pg ? distributor.column_pg - 1 : nil) #name it column_rg?
    return result 
  end

  def unzip(absolutePath)
    system "unzip " + absolutePath + " -d " + Rails.root.join('public', 'uploads', 'unpacked').to_s
  end

  def getFileName(absolutePath)
    index = absolutePath.rindex('/')
    return absolutePath[index + 1, absolutePath.length]
  end
  def convert_to_csv(pathToFile)
    path_to_proj = Rails.root.to_s
    path_to_uploads = path_to_proj + '/public/uploads'
    pathToFileSave = ""
    dot_index = pathToFile.rindex('.')
    if dot_index
      pathToFileSave = pathToFile[0, dot_index] + '.csv'
    end
    system('ssconvert ' + pathToFile + ' ' + pathToFileSave)
    return pathToFileSave
  end

  def addData(file_path, last_free_id)
    #get file name without extension
    #we agreed that it would be manufacturer's name
    m_name = file_path.split('/')[file_path.to_s.split('/').size-1].split('.')[0]
    m = Manufacturer.find(:first, :conditions => [ "name = ?", m_name] )
    if m
      route = params[:route][:id]
      path_to_proj = Rails.root.to_s
      query = 'echo "delete from products where manufacturer_id = ' + m.id.to_s + ' and route = \"' + route + '\";" | sqlite3 ' + path_to_proj + '/db/development.sqlite3'
      system(query)
    else
       m = Manufacturer.create(:name => m_name, :distributor_id => params[:distributor][:id])
    end
    file_name = getFileName(file_path)
    output, last_free_id = reorganize_csv((file_path), last_free_id, file_name, m.id) 
    output += '<br>'
    return output, last_free_id
  end

  #oh my god,  sophisticated solution
  def toup (str) 
    str.gsub!('а','А')   
    str.gsub!('б','Б') 
    str.gsub!('в','В') 
    str.gsub!('г','Г') 
    str.gsub!('д','Д') 
    str.gsub!('е','Е') 
    str.gsub!('ж','Ж') 
    str.gsub!('з','З') 
    str.gsub!('и','И') 
    str.gsub!('й','Й') 
    str.gsub!('к','К') 
    str.gsub!('л','Л') 
    str.gsub!('м','М') 
    str.gsub!('н','Н') 
    str.gsub!('о','О') 
    str.gsub!('п','П') 
    str.gsub!('р','Р') 
    str.gsub!('с','С') 
    str.gsub!('т','Т') 
    str.gsub!('у','У') 
    str.gsub!('ф','Ф') 
    str.gsub!('х','Х') 
    str.gsub!('ц','Ц') 
    str.gsub!('ч','Ч') 
    str.gsub!('ш','Ш') 
    str.gsub!('щ','Щ') 
    str.gsub!('ы','Ы') 
    str.gsub!('ь','Ь') 
    str.gsub!('э','Э') 
    str.gsub!('ю','Ю') 
    str.gsub!('я','Я') 
    return str 
   end

end

