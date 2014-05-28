class VarsController < ApplicationController
  # GET /vars
  # GET /vars.json
  def index
    @vars = Var.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vars }
    end
  end

  # GET /vars/1
  # GET /vars/1.json
  def show
    @var = Var.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @var }
    end
  end

  # GET /vars/new
  # GET /vars/new.json
  def new
    @var = Var.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @var }
    end
  end

  # GET /vars/1/edit
  def edit
    @var = Var.find(params[:id])
  end

  # POST /vars
  # POST /vars.json
  def create
    params[:var][:value] = params[:var][:value].gsub(',','.')
    @var = Var.new(params[:var])

    respond_to do |format|
      if @var.save
        format.html { redirect_to vars_url }
        format.json { render json: @var, status: :created, location: @var }
      else
        format.html { render action: "new" }
        format.json { render json: @var.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vars/1
  # PUT /vars/1.json
  def update
    @var = Var.find(params[:id])

    respond_to do |format|
      if @var.update_attributes(params[:var])
        format.html { redirect_to vars_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @var.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vars/1
  # DELETE /vars/1.json
  def destroy
    @var = Var.find(params[:id])
    @var.destroy

    respond_to do |format|
      format.html { redirect_to vars_url }
      format.json { head :no_content }
    end
  end
end
