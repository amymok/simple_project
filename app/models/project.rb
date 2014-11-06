class Project < ActiveRecord::Base
  has_one :general_repair_permit
  has_one :historical_cert_appropriateness
  accepts_nested_attributes_for :general_repair_permit
  accepts_nested_attributes_for :historical_cert_appropriateness

  # Addition Section
  validates_presence_of :name, :if => :active_or_details?
  validates_presence_of :addition_size, :if => :only_if_screener_addition?

  def active_or_details?
    # puts "&&&&&&& what is enter_details: #{status.to_s.include?('enter_details')} &&&&&&&"
    # puts "&&&&&&&& status: #{status.to_s}"
    status.to_s.include?('enter_details') || status.to_s.include?('active')
  end

  def only_if_screener_addition?
    status.to_s.include?('answer_screener') && selected_addition
  end

  def create_needed_permits

    if GeneralRepairPermit.is_needed?(self)

      self.general_repair_permit ||= GeneralRepairPermit.new

      if GeneralRepairPermit.addition_permit_needed?(self)
        update_attributes(general_repair_permit_attributes: {addition: true})
      end

      # Add more subproject check
    end

    if HistoricalCertAppropriateness.is_needed?(self)
      self.historical_cert_appropriateness ||= HistoricalCertAppropriateness.new
      if HistoricalCertAppropriateness.addition_permit_needed?(self)
        update_attributes(historical_cert_appropriateness_attributes: {addition: true})
      end

      # Add more subproject check
    end

    # Add more permits

  end

  # Output: {general_repair_permit => {addition => true, door => true}, historical_form => {addition => true, door => false}}
  def get_require_permits_for_subprojects
    response = {}
    response[:general_repair_permit] = GeneralRepairPermit.subprojects_needs(self)
    response[:historical_cert_appropriateness] = HistoricalCertAppropriateness.subprojects_needs(self)
    # Add more forms and permits here
    # response[:name_of_permit] = PermitClass.is_needed?(self)

    return response
  end 

  # Input:  {general_repair_permit => {addition => true, door => true}, historical_form => {addition => true, door => false}}, true
  # Output: [addition, door]
  # Input:  {general_repair_permit => {addition => true, door => true}, historical_form => {addition => true, door => false}}, false
  # Output: [door]
  def self.get_subprojects_permit_needed(required_permits, permit_needed_check)
    response = []
    required_permits.each do | permit, subproject_pair |
      subproject_pair.each do | subproject, permit_needed |
        if permit_needed == permit_needed_check
          response.push(subproject)
        end
      end
    end
    return response.uniq
  end

  # Input: {general_repair_permit => {addition => true, door => true}, historical_form => {addition => true, door => false}}
  # Output: { general_repair_permit => {addition, door}, historical_form => {addition}}
  def self.get_permits_to_subprojects(required_permits)
    response = {}
    required_permits.each do | permit, subproject_pair |
      subproject_pair.each do | subproject, permit_needed |
        if permit_needed == true
          if response[permit] == nil
            response[permit] = []
          end
          response[permit].push(subproject)
        end
      end
    end
    return response
  end

  def get_permit_needed_info
    response = {}
    response[:required_permits] = get_require_permits_for_subprojects
    # @TODO: May need to manipulate if something in permit_needed, should it be in not_permit, what about if
    # something needs further assistance, do I still apply for permit?
    response[:permit_needed] = self.class.get_subprojects_permit_needed(response[:required_permits], true)
    response[:permit_not_needed] = self.class.get_subprojects_permit_needed(response[:required_permits], false)
    response[:further_assistance_needed] = self.class.get_subprojects_permit_needed(response[:required_permits], nil)
    #response[:subproject_to_permits] = self.class.get_subproject_to_permits
    response[:permits_to_subprojects] = self.class.get_permits_to_subprojects(response[:required_permits])
    return response

    # permit_not_needed only if it doesn't exist in permit_needed or further_assistance_needed


  end

end
