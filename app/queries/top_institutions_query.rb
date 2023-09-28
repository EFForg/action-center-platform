class TopInstitutionsQuery
  def self.run(**args)
    new(**args).run
  end

  def initialize(action_page:, limit: 300, exclude: [])
    @action_page = action_page
    @limit = limit
    @exclusions = exclude.compact.map(&:id)
  end

  def run
    action_page.institutions
      .where.not(id: exclusions)
      .left_outer_joins(affiliations: [:signature])
      .distinct
      # TODO: break up / document
      .select("institutions.*, COUNT(signatures.id) AS sig_count")
      .group("institutions.id")
      .order("sig_count DESC", "institutions.name")
      .limit(limit)
  end

  private

  attr_reader :action_page, :limit, :exclusions

  def source_collection
    @source_collection ||= action_page.institutions
    return @source_collection if exclusions.empty?
    @source_collection = @source_collection.where.not(id: exclusions)
  end
end
