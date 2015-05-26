class Ability
  include CanCan::Ability

  def initialize(user)
    define_permissions(user)
  end

  private

  def define_permissions(user)
    Permission.all.each do |permission|
      if user.has_role?(permission.role)
        can permission.ability, permission.models
      end
    end
  end
end

class Permission < Struct.new(:role, :ability, :models)
  SUPER_ADMIN_MODELS = [Role, User]

  ADMIN_MODELS = [Address, Drug, DrugType, EdtaCode, EpisodeType, EsrfInfo,
                  FluidDescription, InfectionOrganism, MedicationRoute,
                  ModalityCode, ModalityReason, OrganismCode,
                  PatientEventType, PrdCode]

  CLINICAL_MODELS = [ExitSiteInfection, Medication, Modality, Patient,
                     PatientEvent, PatientProblem, PeritonitisEpisode]


  def self.admin_models
    ADMIN_MODELS + CLINICAL_MODELS
  end

  def self.all
    [ Permission.new(:super_admin, :manage, :all),
      Permission.new(:admin, :manage, admin_models),
      Permission.new(:clinician, :manage, CLINICAL_MODELS) ]
  end
end
