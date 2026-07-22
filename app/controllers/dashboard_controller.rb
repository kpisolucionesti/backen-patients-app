class DashboardController < ApplicationController
    before_action :authenticate_user!

    def stats
        authorize!('emergencia.view')

        cache_key = "dashboard/stats/#{params[:year] || Date.current.year}/#{Date.current.strftime('%Y-%m-%d')}"
        data = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          compute_stats
        end
        render json: data, status: :ok
    end

    private

    def compute_stats
        year = params[:year] || Date.current.year
        today = Date.current

        year_start = Date.new(year.to_i, 1, 1)
        year_end = Date.new(year.to_i, 12, 31)

        # -- Emergencias --
        year_emergencies = Emergency.where(ingress_date: year_start..year_end)

        total_emergencies = year_emergencies.count
        active_emergencies = year_emergencies.where(status: Emergency::STATUS_ATENDIDO).count

        today_emergencies = Emergency.where(ingress_date: today).count
        week_emergencies = Emergency.where(ingress_date: today.beginning_of_week..today.end_of_week).count
        month_emergencies = Emergency.where(ingress_date: today.beginning_of_month..today.end_of_month).count

        by_status = {}
        [0, 1, 2, 3, 4, 5].each do |s|
            count = year_emergencies.where(status: s).count
            by_status[s.to_s] = count if count > 0
        end

        by_classification = {}
        classifications = year_emergencies.where.not(classification: nil).group(:classification).count
        classifications.each { |k, v| by_classification[k] = v }
        null_class = year_emergencies.where(classification: nil).count
        by_classification['null'] = null_class if null_class > 0

        emergencies_by_month = year_emergencies
            .group("to_char(ingress_date, 'YYYY-MM')")
            .count
            .map { |month, count| { month: month, count: count } }
            .sort_by { |m| m[:month] }

        recent_emergencies = Emergency.includes(:patient, emergency_doctors: :doctor)
            .where('created_at >= ?', 24.hours.ago)
            .order(created_at: :desc)
            .limit(20)
            .map do |e|
            {
                patient_name: e.patient&.name,
                patient_lastname: e.patient&.lastname,
                doctor_name: e.emergency_doctors.find_by(primary: true)&.doctor&.name,
                status: e.status,
            }
        end

        closed = year_emergencies.where.not(egress_at: nil)
        avg_wait_time = closed.average("EXTRACT(EPOCH FROM (egress_at - created_at)) / 60")&.round || 0

        avg_wait_by_month = closed
            .group("to_char(created_at, 'YYYY-MM')")
            .average("EXTRACT(EPOCH FROM (egress_at - created_at)) / 60")
            .map { |month, avg| { month: month, avg_min: avg.round } }
            .sort_by { |m| m[:month] }

        by_hour = {}
        (0..23).each { |h| by_hour[h.to_s] = 0 }
        year_emergencies.group("EXTRACT(HOUR FROM created_at)::int").count.each do |hour, count|
            by_hour[hour.to_s] = count
        end

        # -- Citas --
        year_appointments = Appointment.where(appointment_date: year_start..year_end)

        appointments_today = Appointment.where(appointment_date: today.all_day).count
        appointments_upcoming = Appointment.where("appointment_date >= ?", Time.current)
                                            .where(status: %w[scheduled confirmed]).count

        appointments_by_month = year_appointments
            .group("to_char(appointment_date, 'YYYY-MM')")
            .count
            .map { |month, count| { month: month, count: count } }
            .sort_by { |m| m[:month] }

        appointments_by_status = {}
        %w[scheduled confirmed in_consultation completed cancelled no_show].each do |s|
            count = year_appointments.where(status: s).count
            appointments_by_status[s] = count if count > 0
        end

        # -- Cirugías --
        year_surgeries = Surgery.where(surgery_date: year_start..year_end)

        surgeries_total = year_surgeries.count

        surgeries_by_month = year_surgeries
            .group("to_char(surgery_date, 'YYYY-MM')")
            .count
            .map { |month, count| { month: month, count: count } }
            .sort_by { |m| m[:month] }

        surgeries_by_status = {}
        %w[scheduled in_progress completed cancelled].each do |s|
            count = year_surgeries.where(status: s).count
            surgeries_by_status[s] = count if count > 0
        end

        surgeries_by_type = year_surgeries
            .where.not(surgery_type: nil)
            .group(:surgery_type)
            .count
            .map { |type, count| { type: type, count: count } }
            .sort_by { |t| -t[:count] }

        # -- Pacientes --
        total_patients = Patient.where(disabled: [nil, false]).count

        {
            # Emergencias
            active_emergencies: active_emergencies,
            total_emergencies: total_emergencies,
            today_emergencies: today_emergencies,
            week_emergencies: week_emergencies,
            month_emergencies: month_emergencies,
            by_status: by_status,
            by_classification: by_classification,
            emergencies_by_month: emergencies_by_month,
            recent_emergencies: recent_emergencies,
            avg_wait_time: avg_wait_time,
            avg_wait_by_month: avg_wait_by_month,
            by_hour: by_hour,
            # Citas
            appointments_today: appointments_today,
            appointments_upcoming: appointments_upcoming,
            appointments_by_month: appointments_by_month,
            appointments_by_status: appointments_by_status,
            # Cirugías
            surgeries_total: surgeries_total,
            surgeries_by_month: surgeries_by_month,
            surgeries_by_status: surgeries_by_status,
            surgeries_by_type: surgeries_by_type,
            # Pacientes
            total_patients: total_patients,
        }
    end
end
