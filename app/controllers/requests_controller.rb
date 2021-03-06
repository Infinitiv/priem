class RequestsController < ApplicationController
  require 'builder'
  require 'net/http'
  # GET /requests
  # GET /requests.json
  def index
    @requests = Request.paginate(:page => params[:page], :per_page => 30)

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
    @dictionaries = dictionaries

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
    case Rails.env
      when 'development' then url = 'priem.edu.ru:8000'
      when 'production' then url = '127.0.0.1:8080'
    end
    method = '/' + Query.find(params[:request][:query_id]).name
    request = data(method)
    uri = URI.parse('http://' + url + '/import/importservice.svc')
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
    when '/dictionarydetails'
      data = Builder::XmlMarkup.new(indent: 2)
      data.Root do |root|
      auth_data(root)
	data.GetDictionaryContent do |gdc|
	  gdc.DictionaryCode params[:dictionary_id]
	end
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
          campaign_info(pd) if params[:campaign_info]
	  admission_info(pd) if params[:admission_info]
	  applications(pd) if params[:applications]
        end
      end
    when '/import'
      data = Builder::XmlMarkup.new(indent: 2)
      data.Root do |root|
        auth_data(root)
        data.PackageData do |pd|
          campaign_info(pd) if params[:campaign_info]
	  admission_info(pd) if params[:admission_info]
	  applications(pd) if params[:applications]
        end
      end
    when '/delete'
      data = Builder::XmlMarkup.new(indent: 2)
      data.Root do |root|
        auth_data(root)
        data.DataForDelete do |pd|
	  applications_del(pd) if params[:applications]
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
	    i.NumberTargetO cm.number_target_o if cm.number_target_o
	    i.NumberTargetOZ cm.number_target_oz if cm.number_target_oz
	    i.NumberTargetZ cm.number_target_z if cm.number_target_z	    
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
		cg.TargetOrganizations do |tos|
		  cm.target_organizations.each do |tom|
		    tos.TargetOrganization do |to|
		      to.UID tom.id
		      to.TargetOrganizationName tom.target_organization_name
		      to.Items do |i|
			tom.competitive_group_target_items.each do |cgtim|  
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
		cg.EntranceTestItems do |etis|
		cm.entrance_test_items.each do |etim|
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
    applications = Builder::XmlMarkup.new(indent: 2)
    @a = Application.where("last_dany_day > ? or original_received_date > ?", 0, 0)
    root.Applications do |as|
      @a.each do |am|
      as.Application do |a|
	a.UID am.id
	a.ApplicationNumber [am.campaign.year_start, "%04d" % am.application_number].join('-')
	a.Entrant do |e|
	  e.UID am.id
	  e.FirstName am.entrant_first_name
	  e.MiddleName am.entrant_middle_name
	  e.LastName am.entrant_last_name
	  e.GenderID am.gender_id
	end
	a.RegistrationDate am.registration_date.to_datetime
	a.LastDenyDate am.last_dany_day.to_datetime if am.last_dany_day
	a.NeedHostel am.need_hostel
	a.StatusID am.status_id
	a.SelectedCompetitiveGroups do |scg|
	  scg.CompetitiveGroupID 1 if am.lech_budget || am.lech_paid
	  scg.CompetitiveGroupID 2 if am.ped_budget || am.ped_paid
	  scg.CompetitiveGroupID 3 if am.stomat_budget || am.stomat_paid
	end
	a.SelectedCompetitiveGroupItems do |scgi|
	  scgi.CompetitiveGroupItemID 1 if am.lech_budget || am.lech_paid
	  scgi.CompetitiveGroupItemID 2 if am.ped_budget || am.ped_paid
	  scgi.CompetitiveGroupItemID 3 if am.stomat_budget || am.stomat_paid
	end
	a.FinSourceAndEduForms do |fsaef|
	  if am.lech_budget || am.ped_budget || am.stomat_budget
	    fsaef.FinSourceEduForm do |fsef|
	      fsef.FinanceSourceID 14
	      fsef.EducationFormID 11
	    end
	  end
	  if am.lech_paid || am.ped_paid || am.stomat_paid
	    fsaef.FinSourceEduForm do |fsef|
	      fsef.FinanceSourceID 15
	      fsef.EducationFormID 11
	    end
	  end
	  if am.target_organization_id
	    fsaef.FinSourceEduForm do |fsef|
	      fsef.FinanceSourceID 16
	      fsef.EducationFormID 11
	      fsef.TargetOrganizationUID am.target_organization_id
	    end
	  end
	end
	if am.russian || am.chemistry || am.biology
	a.EntranceTestResults do |etrs|
	  if am.russian
	    if am.lech_budget || am.lech_paid
	      etrs.EntranceTestResult do |etr|
		etr.UID 1.to_s + am.application_number.to_s + "russian"
		etr.ResultValue am.russian
		etr.ResultSourceTypeID 1
		etr.EntranceTestSubject do |ets|
		  ets.SubjectID 1
		end
		etr.EntranceTestTypeID 1
		etr.CompetitiveGroupID 1
	      end
	    end
	    if am.ped_budget || am.ped_paid
	      etrs.EntranceTestResult do |etr|
		etr.UID 2.to_s + am.application_number.to_s + "russian"
		etr.ResultValue am.russian
		etr.ResultSourceTypeID 1
		etr.EntranceTestSubject do |ets|
		  ets.SubjectID 1
		end
		etr.EntranceTestTypeID 1
		etr.CompetitiveGroupID 2
	      end
	    end
	    if am.stomat_budget || am.stomat_paid
	      etrs.EntranceTestResult do |etr|
		etr.UID 3.to_s + am.application_number.to_s + "russian"
		etr.ResultValue am.russian
		etr.ResultSourceTypeID 1
		etr.EntranceTestSubject do |ets|
		  ets.SubjectID 1
		end
		etr.EntranceTestTypeID 1
		etr.CompetitiveGroupID 3
	      end
	    end
	  end
	  if am.biology
	    if am.lech_budget || am.lech_paid
	      etrs.EntranceTestResult do |etr|
		etr.UID 1.to_s + am.application_number.to_s + "biology"
		etr.ResultValue am.biology
		etr.ResultSourceTypeID 1
		etr.EntranceTestSubject do |ets|
		  ets.SubjectID 4
		end
		etr.EntranceTestTypeID 1
		etr.CompetitiveGroupID 1
	      end
	    end
	    if am.ped_budget || am.ped_paid
	      etrs.EntranceTestResult do |etr|
		etr.UID 2.to_s + am.application_number.to_s + "biology"
		etr.ResultValue am.biology
		etr.ResultSourceTypeID 1
		etr.EntranceTestSubject do |ets|
		  ets.SubjectID 4
		end
		etr.EntranceTestTypeID 1
		etr.CompetitiveGroupID 2
	      end
	    end
	    if am.stomat_budget || am.stomat_paid
	      etrs.EntranceTestResult do |etr|
		etr.UID 3.to_s + am.application_number.to_s + "biology"
		etr.ResultValue am.biology
		etr.ResultSourceTypeID 1
		etr.EntranceTestSubject do |ets|
		  ets.SubjectID 4
		end
		etr.EntranceTestTypeID 1
		etr.CompetitiveGroupID 3
	      end
	    end
	  end
	  if am.chemistry
	    if am.lech_budget || am.lech_paid
	      etrs.EntranceTestResult do |etr|
		etr.UID 1.to_s + am.application_number.to_s + "chemistry"
		etr.ResultValue am.chemistry
		etr.ResultSourceTypeID 1
		etr.EntranceTestSubject do |ets|
		  ets.SubjectID 11
		end
		etr.EntranceTestTypeID 1
		etr.CompetitiveGroupID 1
	      end
	    end
	    if am.ped_budget || am.ped_paid
	      etrs.EntranceTestResult do |etr|
		etr.UID 2.to_s + am.application_number.to_s + "chemistry"
		etr.ResultValue am.chemistry
		etr.ResultSourceTypeID 1
		etr.EntranceTestSubject do |ets|
		  ets.SubjectID 11
		end
		etr.EntranceTestTypeID 1
		etr.CompetitiveGroupID 2
	      end
	    end
	    if am.stomat_budget || am.stomat_paid
	      etrs.EntranceTestResult do |etr|
		etr.UID 3.to_s + am.application_number.to_s + "chemistry"
		etr.ResultValue am.chemistry
		etr.ResultSourceTypeID 1
		etr.EntranceTestSubject do |ets|
		  ets.SubjectID 11
		end
		etr.EntranceTestTypeID 1
		etr.CompetitiveGroupID 3
	      end
	    end
	  end
	end
	end
	a.ApplicationDocuments do |ad|
	    ad.IdentityDocument do |id|
	      id.OriginalReceived true
	      id.DocumentSeries am.document_series if am.document_series
	      id.DocumentNumber am.document_number
	      id.DocumentDate am.document_date
	      id.IdentityDocumentTypeID 1
	      id.NationalityTypeID 1
	      id.BirthDate am.birth_date
	    end
	    ad.EduDocuments do |eds|
	      eds.EduDocument do |ed|
		if am.edu_document_type_id == 1
		  ed.SchoolCertificateDocument do |scd|
		    scd.OriginalReceived am.original_received
		    scd.OriginalReceivedDate am.original_received_date if am.original_received
		    scd.DocumentSeries am.edu_document_series
		    scd.DocumentNumber am.edu_document_number
		  end
		else
		  ed.MiddleEduDiplomaDocument do |medd|
		    medd.OriginalReceived am.original_received
		    medd.OriginalReceivedDate am.original_received_date ? am.original_received_date : am.registration_date
		    medd.DocumentSeries am.edu_document_series
		    medd.DocumentNumber am.edu_document_number
		  end
		end
	      end
	    end
	  end
      end
      end
    end
  end

  def applications_del(root)
    applications_del = Builder::XmlMarkup.new(indent: 2)
    @a = Application.find_all_by_status_id(0)
    root.Applications do |as|
      @a.each do |am|
	as.Application do |a|
	  a.ApplicationNumber am.application_number
	  a.RegistrationDate am.registration_date.to_datetime
	end
	as.Application do |a|
	  a.ApplicationNumber am.application_number
	  a.RegistrationDate am.registration_date.to_datetime.to_s.gsub('+00:00', '')
	end
      end
    end
  end
  
  def order_of_admission(root)
    
  end
  
  def dictionaries
    method = '/dictionary'
    request = data(method)
    uri = URI.parse('http://priem.edu.ru:8000/import/importservice.svc')
    http = Net::HTTP.new(uri.host, uri.port)
    headers = {'Content-Type' => 'text/xml'}
    response = http.post(uri.path + method, request, headers)
    h = Hash.from_xml response.body
    dictionaries = Hash.new
    h['Dictionaries']['Dictionary'].each do |d|
      dictionaries[d['Code']] = d['Name']
    end
  end
  
end
