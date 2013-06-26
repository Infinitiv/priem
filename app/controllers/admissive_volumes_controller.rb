class AdmissiveVolumesController < ApplicationController
  # GET /admissive_volumes
  # GET /admissive_volumes.json
  def index
    @admissive_volumes = AdmissiveVolume.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admissive_volumes }
    end
  end

  # GET /admissive_volumes/1
  # GET /admissive_volumes/1.json
  def show
    @admissive_volume = AdmissiveVolume.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admissive_volume }
    end
  end

  # GET /admissive_volumes/new
  # GET /admissive_volumes/new.json
  def new
    @admissive_volume = AdmissiveVolume.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admissive_volume }
    end
  end

  # GET /admissive_volumes/1/edit
  def edit
    @admissive_volume = AdmissiveVolume.find(params[:id])
  end

  # POST /admissive_volumes
  # POST /admissive_volumes.json
  def create
    @admissive_volume = AdmissiveVolume.new(params[:admissive_volume])

    respond_to do |format|
      if @admissive_volume.save
        format.html { redirect_to @admissive_volume, notice: 'Admissive volume was successfully created.' }
        format.json { render json: @admissive_volume, status: :created, location: @admissive_volume }
      else
        format.html { render action: "new" }
        format.json { render json: @admissive_volume.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admissive_volumes/1
  # PUT /admissive_volumes/1.json
  def update
    @admissive_volume = AdmissiveVolume.find(params[:id])

    respond_to do |format|
      if @admissive_volume.update_attributes(params[:admissive_volume])
        format.html { redirect_to @admissive_volume, notice: 'Admissive volume was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admissive_volume.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admissive_volumes/1
  # DELETE /admissive_volumes/1.json
  def destroy
    @admissive_volume = AdmissiveVolume.find(params[:id])
    @admissive_volume.destroy

    respond_to do |format|
      format.html { redirect_to admissive_volumes_url }
      format.json { head :no_content }
    end
  end
end
