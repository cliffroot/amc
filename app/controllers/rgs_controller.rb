class RgsController < ApplicationController
  # GET /rgs
  # GET /rgs.json
  def index
    @rgs = Rg.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rgs }
    end
  end

  # GET /rgs/1
  # GET /rgs/1.json
  def show
    @rg = Rg.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rg }
    end
  end

  # GET /rgs/new
  # GET /rgs/new.json
  def new
    @rg = Rg.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rg }
    end
  end

  # GET /rgs/1/edit
  def edit
    @rg = Rg.find(params[:id])
  end

  # POST /rgs
  # POST /rgs.json
  def create
    output = ""
    #load the file 
    if (params[:file])
      uploaded_io = params[:file]
      filename = save_file(uploaded_io)
      up_filename = filename[0,filename.rindex('.')] + '.csv'
      system('ssconvert ' + filename + ' ' + up_filename)
      file = File.open(up_filename,'r')

      puts file
      while (line = file.gets)
        print line
        begin 
          #create some new modificators (rg) get from the file
          columns = line.force_encoding("UTF-8").split(',')
          Rg.create({:manufacturer => columns[0].force_encoding("UTF-8"), :code => columns[1].force_encoding("UTF-8"), :value => columns[2].force_encoding("UTF-8")}, :without_protection => true)
        rescue
          print 'wrong utf-8'
        end
      end
      file.close
      output = "File was uploaded succesfully"
    end
    respond_to do |format|
        format.html { redirect_to '/rgs', notice: output.html_safe}
    end
  end

  def save_file(uploaded_io)
      absolutePath = Rails.root.join('public', 'uploads', uploaded_io.original_filename).to_s
      file = File.open(absolutePath, 'wb')
      file << uploaded_io.read
      file.close
      return absolutePath
  end

  # PUT /rgs/1
  # PUT /rgs/1.json
  def update
    @rg = Rg.find(params[:id])

    respond_to do |format|
      if @rg.update_attributes(params[:rg])
        format.html { redirect_to @rg, notice: 'Rg was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rgs/1
  # DELETE /rgs/1.json
  def destroy
    @rg = Rg.find(params[:id])
    @rg.destroy

    respond_to do |format|
      format.html { redirect_to rgs_url }
      format.json { head :no_content }
    end
  end
end
