class Project < ActiveRecord::Base
  has_one :general_repair_permit
  has_one :historical_cert_appropriateness
  accepts_nested_attributes_for :general_repair_permit
  accepts_nested_attributes_for :historical_cert_appropriateness

  # Addition Section
  validates_presence_of :addition_size, :if => :only_if_screener_addition?

  def only_if_screener_addition?
    status.to_s.include?('answer_screener') && selected_addition
  end

  # Add more forms and permits here
  # accepts_nested_attributes_for :permit_name

  # def get_require_permits_for_subprojects(selected_subproject, )
  #   if selected_subproject
  #     GeneralRepairPermit.is_permit_needed(selected_subproject, )

  # end
#:required_permits=>{:general_repair_permit=>{:selected_addition=>true}}



  # # Input: {addition => true, door => true}, true
  # # Output: {}

  # def self.get_subproject_to_permits(required_permits, permit_needed)
  #   response = {}
  #   permit_needed.each do | subproject |
  #       response[subproject] = []
  #     required_permits.each do | permit, subproject_pair |
  #       response[subproject].push(permit)
  #     end
  #   end
  # end

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

      # @permit_needs = @project.get_require_permits_for_subprojects
      # @subjprojects_permit_needed = Project.get_subprojects_permit_needed(@permit_needs)
      # @subjprojects_permit_not_needed = Project.get_subprojects_permit_not_needed(@permit_needs)
      # @subjprojects_further_assistance_needed = Project.get_subprojects_further_assistance_needed(@permit_needs)
end



  # def update_permit_needs(selected_proj, displayed_proj_text, attribute, is_permit_needed, permit_needs)
  #   if to_bool(selected_proj)
  #     is_needed = is_permit_needed.call
  #     if is_needed
  #       permit_needs["permit_needed"].push(displayed_proj_text)
  #       update_attribute(attribute, true)
  #     elsif is_needed == false
  #       permit_needs["permit_not_needed"].push(displayed_proj_text)
  #       update_attribute(attribute, false)
  #     else
  #       permit_needs["further_assistance_needed"].push(displayed_proj_text)
  #       update_attribute(attribute, nil)
  #     end
  #   end
  # end

  # def update_permit_needs_for_projects
  #   permit_needs = { "permit_needed" => [], "permit_not_needed" => [], "further_assistance_needed" => [] }

  #   update_permit_needs(selected_addition, "Addition", "addition", method(:addition_permit_needed?), permit_needs)
  #   update_permit_needs(selected_acs_struct, "Shed/Garage", "acs_struct", method(:acs_struct_permit_needed?), permit_needs)
  #   update_permit_needs(selected_deck, "Deck", "deck", method(:deck_permit_needed?), permit_needs)
  #   update_permit_needs(selected_pool, "Swimming Pool", "pool", method(:pool_permit_needed?), permit_needs)
  #   update_permit_needs(selected_cover, "Carport/Outdoor Cover", "cover", method(:cover_permit_needed?), permit_needs)
  #   update_permit_needs(selected_window, "Windows", "window", method(:window_permit_needed?), permit_needs)
  #   update_permit_needs(selected_door, "Doors", "door", method(:door_permit_needed?), permit_needs)
  #   update_permit_needs(selected_wall, "Walls", "wall", method(:wall_permit_needed?), permit_needs)
  #   update_permit_needs(selected_siding, "Replace Siding", "siding", method(:siding_permit_needed?), permit_needs)
  #   update_permit_needs(selected_floor, "Floors", "floor", method(:floor_permit_needed?), permit_needs)

  #   return permit_needs
  # end
