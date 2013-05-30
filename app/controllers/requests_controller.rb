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
      data = Builder::XmlMarkup.new(indent: 2)
      data.Root do |root|
        auth_data(root)
      end
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
      data = Builder::XmlMarkup.new(indent: 2)
      data.Root do |root|
        auth_data(root)
        data.PackageData do |pd|
          campaign_info(pd)
	  admission_info(pd)
        end
      end
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
    admission_info = Builder::XmlMarkup.new(indent: 2)
    @c = AdmissionVolume.all
    root.AdmissionInfo do |ai|
      ai.AdmissionVolume do |av|
	@c.each do |cm|
	  av.Item do |i|
	    i.UID cm.id
	    i.CampaignUID cm.campaign_id
	    i.EducationLevelID cm.education_level_id
	    i.Course cm.course
	    i.DirectionID cm.direction_id
	    i.NumberBudgetO cm.number_budget_o if cm.number_budget_o
	    i.NumberBudgetOZ cm.number_budget_oz if cm.number_budget_oz
	    i.NumberBudgetZ cm.number_budget_z if cm.number_budget_z
	    i.NumberPaidO cm.number_paid_o if cm.number_paid_o
	    i.NumberPaidOZ cm.number_paid_oz if cm.number_paid_oz
	    i.NumberPaidZ cm.number_paid_z if cm.number_paid_z
	  end
	end
      end
      ai.CompetitiveGroups do |cgs|
	@c = CompetitiveGroup.all 
	@c.each do |cm|
	  cgs.CompetitiveGroup do |cg|
	    cg.UID cm.id
	    cg.CampaignUID cm.campaign_id
	    cg.Course cm.course
	    cg.Name cm.name
	    cg.Items do |i|
	      cm.competitive_group_items.each do |cgim|
		i.CompetitiveGroupItem do |cgi|
		  cgi.UID cgim.id
		  cgi.EducationLevelID cgim.education_level_id
		  cgi.DirectionID cgim.direction_id
		  cgi.NumberBudgetO cgim.number_budget_o if cgim.number_budget_o
		  cgi.NumberBudgetOZ cgim.number_budget_oz if cgim.number_budget_oz
		  cgi.NumberBudgetZ cgim.number_budget_z if cgim.number_budget_z
		  cgi.NumberPaidO cgim.number_paid_o if cgim.number_paid_o
		  cgi.NumberPaidOZ cgim.number_paid_oz if cgim.number_paid_oz
		  cgi.NumberPaidZ cgim.number_paid_z if cgim.number_paid_z
		end
	      end
	    end
	      cm.target_organizations.each do |tom|
		cg.TargetOrganizations do |tos|
		  tos.TargetOrganization do |to|
		    to.UID tom.id
		    to.TargetOrganizationName tom.target_organization_name
		    tom.comptititve_group_target_items.each do |cgtim|  
		      to.Items do |i|
			i.CompetitiveGroupTargetItem do |cgti|
			  cgti.UID cgtim.id
			  cgti.EducationLevelID cgtim.education_level
			  cgti.NumberTargetO cgtim.number_target_o if cgtim.number_target_o
			  cgti.NumberTargetOZ cgtim.number_target_oz if cgtim.number_target_oz
			  cgti.NumberTargetZ cgtim.number_target_z if cgtim.number_target_z
			  cgti.DirectionID cgtim.direction_id
			end
		      end
		    end
		  end
		end
	      end
	      cm.entrance_test_items.each do |etim|
		cg.EntranceTestItems do |etis|
		  etis.EntranceTestItem do |eti|
		    eti.UID etim.id
		    eti.EntranceTestTypeID etim.entrance_test_type_id
		    eti.Form etim.form
		    eti.MinScore etim.min_score
		    etim.entrance_test_subjects.each do |esm|
		      eti.EntranceTestSubject do |es|
			es.SubjectID esm.subject_id
		      end
		    end
		  end
		end
	      end
	  end
	end
      end
    end
  end

  def applications(root)
    
  end

  def order_of_admission(root)
    
  end
end
