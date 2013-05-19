class RequestsController < ApplicationController
  require 'builder'
  require 'net/http'
  # GET /requests
  # GET /requests.json
  def index
    @requests = Request.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @requests }
    end
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
    @request = Request.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @request }
    end
  end

  # GET /requests/new
  # GET /requests/new.json
  def new
    @request = Request.new
    @queries = Query.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @request }
    end
  end

  # GET /requests/1/edit
  def edit
    @request = Request.find(params[:id])
  end

  # POST /requests
  # POST /requests.json
  def create
    method = '/' + Query.find(params[:request][:query_id]).name
    request = data(method)
    uri = URI.parse('http://priem.edu.ru:8000/import/importservice.svc')
    http = Net::HTTP.new(uri.host, uri.port)
    headers = {'Content-Type' => 'text/xml'}
    response = http.post(uri.path + method, request, headers)
    @request = Request.new(query_id: params[:request][:query_id], input: request, output: response.body)

    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render json: @request, status: :created, location: @request }
      else
        format.html { render action: "new" }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /requests/1
  # PUT /requests/1.json
  def update
    @request = Request.find(params[:id])

    respond_to do |format|
      if @request.update_attributes(params[:request])
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request = Request.find(params[:id])
    @request.destroy

    respond_to do |format|
      format.html { redirect_to requests_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def data(method)
    case method
    when '/dictionary'
      data = Builder::XmlMarkup.new(indent: 2)
      data.Root do |root|
        auth_data(root)
      end
    when '/institutioninfo'
      AuthData.first.to_xml(only: [:login, :pass], camelize: true, skip_types: true, skip_instruct: true)
    when '/validate'
      data = Builder::XmlMarkup.new(indent: 2)
      data.Root do |root|
        auth_data(root)
        data.PackageData do |pd|
          campaign_info(pd)
	  admission_info(pd)
        end
      end
    when '/test/import'
      AuthData.first.to_xml(only: [:login, :pass], camelize: true, skip_types: true, skip_instruct: true) + '<PackageData>' + '<CampaignInfo>' + Campaign.all.to_xml(skip_instruct: true, camelize: true, :skip_types => true, :except => ['updated_at', 'created_at'], :include => {:campaign_dates => {:skip_types => true, camelize: true, :except => ['updated_at', 'created_at', 'campaign_id']}}) + '</CampaignInfo>' + '</PackageData>'
    end
  end

  def auth_data(root)
    auth_data = Builder::XmlMarkup.new(indent: 2)
    @a = AuthData.first
    root.AuthData do |ad|
      ad.Login @a.login
      ad.Pass @a.pass
    end
  end

  def campaign_info(root)
    campaign_info = Builder::XmlMarkup.new(indent: 2)
    @c = Campaign.all
    root.CampaignInfo do |ci|
      ci.Campaigns do |ca|
        @c.each do |cm|
          ca.Campaign do |c|
            c.UID cm.id
            c.Name cm.name
            c.YearStart cm.year_start
            c.YearEnd cm.year_end
            cm.education_forms.each do |efm|
              c.EducationForms do |ef|
                ef.EducationFormID efm.education_form_id
              end
            end
            c.StatusID cm.status_id
            c.EducationLevels do |els|
              cm.education_levels.each do |elm|
                els.EducationLevel do |el|
                  el.Course elm.course
                  el.EducationLevelID elm.education_level_id
                end
              end
            end
            c.CampaignDates do |cds|
              cm.campaign_dates.each do |cdm|
                cds.CampaignDate do |cd|
                  cd.UID cdm.id
                  cd.Course cdm.course
                  cd.EducationLevelID cdm.education_level_id
                  cd.EducationFormID cdm.education_form_id
                  cd.EducationSourceID cdm.education_source_id
                  cd.Stage cdm.stage if cdm.stage
                  cd.DateStart cdm.date_start
                  cd.DateEnd cdm.date_end
                  cd.DateOrder cdm.date_order
                end
              end
            end
          end
        end
      end
    end
  end

  def admission_info(root)
    
  end

  def applications(root)
    
  end

  def order_of_admission(root)
    
  end
end
