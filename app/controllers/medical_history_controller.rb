class MedicalHistoryController < ApplicationController
  before_action :authenticate_user!

  def for_emergency
    authorize!('emergencia.view')
    emergency = Emergency.includes(:patient, :doctors, :vital_signs, :physical_exam,
                                    :medical_plans, :interconsultations, :paraclinical_studies,
                                    :notes, :laboratory_results)
                         .find(params[:emergency_id])

    render json: {
      patient: build_patient(emergency.patient),
      emergency: build_emergency(emergency),
      doctors: emergency.doctors.map { |d| { id: d.id, name: d.name, specialty: d.specialty&.name } },
      primary_doctor: emergency.primary_doctor&.then { |d| { id: d.id, name: d.name } },
      consulting_doctors: emergency.consulting_doctors.map { |d| { id: d.id, name: d.name } },
      vital_signs: emergency.vital_signs.order(recorded_at: :asc).map { |vs|
        { id: vs.id, systolic_bp: vs.systolic_bp, diastolic_bp: vs.diastolic_bp,
          heart_rate: vs.heart_rate, respiratory_rate: vs.respiratory_rate,
          temperature: vs.temperature, oxygen_saturation: vs.oxygen_saturation,
          glucose: vs.glucose, weight: vs.weight, height: vs.height, bmi: vs.bmi,
          recorded_at: vs.recorded_at }
      },
      physical_exam: emergency.physical_exam&.then { |pe|
        { id: pe.id, cabeza: pe.cabeza, ojo: pe.ojo, cuello: pe.cuello, orl: pe.orl,
          torax: pe.torax, cardiovascular: pe.cardiovascular, abdomen: pe.abdomen,
          genitales: pe.genitales, extremidades: pe.extremidades, neurologico: pe.neurologico }
      },
      medical_plans: emergency.medical_plans.order(created_at: :asc).map { |mp|
        { id: mp.id, indication_type: mp.indication_type, description: mp.description,
          status: mp.status, doctor: mp.doctor&.name, created_at: mp.created_at }
      },
      interconsultations: emergency.interconsultations.map { |ic|
        { id: ic.id, reason: ic.reason, observations: ic.observations, status: ic.status,
          doctor_requested: ic.doctor_requested&.name, created_at: ic.created_at }
      },
      paraclinical_studies: emergency.paraclinical_studies.map { |ps|
        { id: ps.id, study_type: ps.study_type, description: ps.description }
      },
      laboratory_results: emergency.laboratory_results.order(result_date: :asc).map { |lr|
        { id: lr.id, result_date: lr.result_date, notes: lr.notes,
          values: lr.lab_result_values.map { |v|
            { parameter_name: v.parameter_name, value: v.value, unit: v.unit, reference_range: v.reference_range }
          }
        }
      },
      notes: emergency.notes.order(created_at: :asc).map { |n|
        { id: n.id, note: n.note, created_by: n.created_by&.name, created_at: n.created_at }
      },
      documents: Document.where(attachable_type: 'Emergency', attachable_id: emergency.id)
                         .map { |d| { id: d.id, file_name: d.file_name, file_type: d.file_type, file_size: d.file_size, created_at: d.created_at } }
    }
  end

  def for_hospitalization
    authorize!('hospitalizacion.view')
    hospitalization = Hospitalization.includes(emergency: [:patient, :doctors, :vital_signs,
                                                           :physical_exam, :medical_plans,
                                                           :interconsultations, :paraclinical_studies,
                                                           :notes, :laboratory_results])
                                      .find(params[:hospitalization_id])

    emergency = hospitalization.emergency

    render json: {
      patient: build_patient(emergency.patient),
      emergency: build_emergency(emergency),
      hospitalization: {
        id: hospitalization.id,
        admission_date: hospitalization.admission_date,
        discharge_date: hospitalization.discharge_date,
        status: hospitalization.status,
        admission_diagnosis: hospitalization.admission_diagnosis,
        discharge_diagnosis: hospitalization.discharge_diagnosis,
        discharge_summary: hospitalization.discharge_summary,
        length_of_stay_days: hospitalization.length_of_stay_days,
        room: hospitalization.room&.name,
        attending_doctor: hospitalization.attending_doctor&.name,
        admitting_doctor: hospitalization.admitting_doctor&.name
      },
      doctors: emergency.doctors.map { |d| { id: d.id, name: d.name, specialty: d.specialty&.name } },
      primary_doctor: emergency.primary_doctor&.then { |d| { id: d.id, name: d.name } },
      consulting_doctors: emergency.consulting_doctors.map { |d| { id: d.id, name: d.name } },
      vital_signs: emergency.vital_signs.order(recorded_at: :asc).map { |vs|
        { id: vs.id, systolic_bp: vs.systolic_bp, diastolic_bp: vs.diastolic_bp,
          heart_rate: vs.heart_rate, respiratory_rate: vs.respiratory_rate,
          temperature: vs.temperature, oxygen_saturation: vs.oxygen_saturation,
          glucose: vs.glucose, weight: vs.weight, height: vs.height, bmi: vs.bmi,
          recorded_at: vs.recorded_at }
      },
      physical_exam: emergency.physical_exam&.then { |pe|
        { id: pe.id, cabeza: pe.cabeza, ojo: pe.ojo, cuello: pe.cuello, orl: pe.orl,
          torax: pe.torax, cardiovascular: pe.cardiovascular, abdomen: pe.abdomen,
          genitales: pe.genitales, extremidades: pe.extremidades, neurologico: pe.neurologico }
      },
      medical_plans: emergency.medical_plans.order(created_at: :asc).map { |mp|
        { id: mp.id, indication_type: mp.indication_type, description: mp.description,
          status: mp.status, doctor: mp.doctor&.name, created_at: mp.created_at }
      },
      interconsultations: emergency.interconsultations.map { |ic|
        { id: ic.id, reason: ic.reason, observations: ic.observations,
          status: ic.status, doctor_requested: ic.doctor_requested&.name }
      },
      paraclinical_studies: emergency.paraclinical_studies.map { |ps|
        { id: ps.id, study_type: ps.study_type, description: ps.description }
      },
      laboratory_results: emergency.laboratory_results.order(result_date: :asc).map { |lr|
        { id: lr.id, result_date: lr.result_date, notes: lr.notes,
          values: lr.lab_result_values.map { |v|
            { parameter_name: v.parameter_name, value: v.value, unit: v.unit, reference_range: v.reference_range }
          }
        }
      },
      notes: emergency.notes.order(created_at: :asc).map { |n|
        { id: n.id, note: n.note, created_by: n.created_by&.name, created_at: n.created_at }
      },
      hospitalization_notes: hospitalization.hospitalization_notes.order(recorded_at: :asc).map { |hn|
        { id: hn.id, note_type: hn.note_type, shift: hn.shift, subjective: hn.subjective,
          objective: hn.objective, assessment: hn.assessment, plan: hn.plan,
          recorded_at: hn.recorded_at, created_by: hn.created_by&.name }
      },
      fluid_balances: hospitalization.fluid_balances.order(recorded_at: :asc).map { |fb|
        { id: fb.id, balance_type: fb.balance_type, fluid_type: fb.fluid_type,
          amount: fb.amount, unit: fb.unit, recorded_at: fb.recorded_at, notes: fb.notes }
      },
      fluid_balance_summary: {
        total_intake: hospitalization.total_fluid_intake,
        total_output: hospitalization.total_fluid_output,
        net_balance: hospitalization.net_fluid_balance
      },
      medication_administrations: hospitalization.medication_administrations.order(scheduled_at: :asc).map { |ma|
        { id: ma.id, medication_name: ma.medication_name, dosage: ma.dosage, route: ma.route,
          frequency: ma.frequency, status: ma.status, scheduled_at: ma.scheduled_at,
          administered_at: ma.administered_at, administered_by: ma.administered_by&.name, notes: ma.notes }
      },
      surgeries: hospitalization.surgeries.order(surgery_date: :asc).map { |s|
        { id: s.id, surgery_type: s.surgery_type, description: s.description,
          surgeon_name: s.surgeon_name, surgery_date: s.surgery_date,
          scheduled_start_time: s.scheduled_start_time, scheduled_end_time: s.scheduled_end_time,
          actual_start_time: s.actual_start_time, actual_end_time: s.actual_end_time,
          status: s.status, result: s.result }
      },
      documents: Document.where(attachable_type: 'Hospitalization', attachable_id: hospitalization.id)
                         .or(Document.where(attachable_type: 'Emergency', attachable_id: emergency.id))
                         .map { |d| { id: d.id, file_name: d.file_name, file_type: d.file_type, file_size: d.file_size, created_at: d.created_at } }
    }
  end

  private

  def build_patient(patient)
    {
      id: patient.id, ci: patient.ci, name: patient.name, lastname: patient.lastname,
      gender: patient.gender, age: patient.age, birthday: patient.birthday,
      medical_history_number: patient.medical_history_number,
      representante: patient.representante, representante_ci: patient.representante_ci,
      disabled: patient.disabled
    }
  end

  def build_emergency(emergency)
    {
      id: emergency.id, ingress_date: emergency.ingress_date, egress_at: emergency.egress_at,
      status: emergency.status, classification: emergency.classification,
      diagnostic: emergency.diagnostic, treatment: emergency.treatment,
      observations: emergency.observations, reason_for_consultation: emergency.reason_for_consultation,
      current_illness: emergency.current_illness, discharge_note: emergency.discharge_note,
      admission_note: emergency.admission_note, medical_exit: emergency.medical_exit,
      transfer: emergency.transfer, cause_of_death: emergency.cause_of_death
    }
  end
end
