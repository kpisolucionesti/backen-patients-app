class Room < ApplicationRecord
    # def patient_id 
    #     Patient.find_by_id(patient)
    # end
    
    scope :available, -> (){
      where(patient_id:nil)
    }

end
