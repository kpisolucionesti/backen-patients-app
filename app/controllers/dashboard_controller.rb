class DashboardController < ApplicationController
    before_action :authenticate_user!

    def stats
        authorize!('emergencia.view')

        year = params[:year] || Date.current.year

        year_scope = Emergency.where("to_char(ingress_date, 'YYYY') = ?", year.to_s)

        total_patients = Patient.count
        total_emergencies = year_scope.count
        active_emergencies = year_scope.where(status: Emergency::STATUS_ATENDIDO).count

        today = Date.current
        today_count = Emergency.where(ingress_date: today).count
        week_count = Emergency.where(ingress_date: today.beginning_of_week..today.end_of_week).count
        month_count = Emergency.where(ingress_date: today.beginning_of_month..today.end_of_month).count

        by_status = {}
        [0, 1, 2, 3, 4, 5].each do |s|
            count = year_scope.where(status: s).count
            by_status[s.to_s] = count if count > 0
        end

        by_classification = {}
        classifications = year_scope.where.not(classification: nil).group(:classification).count
        classifications.each { |k, v| by_classification[k] = v }
        null_class = year_scope.where(classification: nil).count
        by_classification['null'] = null_class if null_class > 0

        by_month = year_scope
            .group("to_char(ingress_date, 'YYYY-MM')")
            .count
            .map { |month, count| { month: month, count: count } }
            .sort_by { |m| m[:month] }

        recent_emergencies = Emergency.includes(:patient, :emergency_doctors)
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

        closed = year_scope.where.not(egress_at: nil)
        avg_wait_time = closed.average("EXTRACT(EPOCH FROM (egress_at - created_at)) / 60")&.round || 0

        avg_wait_by_month = closed
            .group("to_char(created_at, 'YYYY-MM')")
            .average("EXTRACT(EPOCH FROM (egress_at - created_at)) / 60")
            .map { |month, avg| { month: month, avg_min: avg.round } }
            .sort_by { |m| m[:month] }

        by_hour = {}
        (0..23).each { |h| by_hour[h.to_s] = 0 }
        year_scope.group("EXTRACT(HOUR FROM created_at)::int").count.each do |hour, count|
            by_hour[hour.to_s] = count
        end

        render json: {
            active_emergencies: active_emergencies,
            total_emergencies: total_emergencies,
            total_patients: total_patients,
            today_count: today_count,
            week_count: week_count,
            month_count: month_count,
            by_status: by_status,
            by_classification: by_classification,
            by_month: by_month,
            recent_emergencies: recent_emergencies,
            avg_wait_time: avg_wait_time,
            avg_wait_by_month: avg_wait_by_month,
            by_hour: by_hour,
        }, status: :ok
    end
end
