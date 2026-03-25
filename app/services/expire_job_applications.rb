class ExpireJobApplications
  def self.call
    JobApplication.pending.find_each do |application|
      next unless application.expired?

      application.update!(
        status: "auto_declined",
        reviewed_at: Time.current
      )
    end
  end
end