class Types::QueryType < Types::BaseObject
  field :current_account, Types::Account, null: true do
    description 'Kitsu account details. You must supply an Authorization token in header.'
  end

  def current_account
    User.current
  end

  field :anime, Types::Anime.connection_type, null: false do
    description 'All Anime in the Kitsu database'
  end

  def anime
    ::Anime.all
  end

  field :find_anime_by_id, Types::Anime, null: true do
    description 'Find a single Anime by ID'
    argument :id, ID, required: true
  end

  def find_anime_by_id(id:)
    ::Anime.find_by(id: id)
  end

  field :find_anime_by_slug, Types::Anime, null: true do
    description 'Find a single Anime by Slug'
    argument :slug, String, required: true
  end

  def find_anime_by_slug(slug:)
    ::Anime.find_by(slug: slug)
  end

  field :manga, Types::Manga.connection_type, null: false do
    description 'All Manga in the Kitsu database'
  end

  def manga
    ::Manga.all
  end

  field :find_manga_by_id, Types::Manga, null: true do
    description 'Find a single Manga by ID'
    argument :id, ID, required: true
  end

  def find_manga_by_id(id:)
    ::Manga.find_by(id: id)
  end

  field :find_manga_by_slug, Types::Manga, null: true do
    description 'Find a single Manga by Slug'
    argument :slug, String, required: true
  end

  def find_manga_by_slug(slug:)
    ::Manga.find_by(slug: slug)
  end

  field :global_trending, Types::Interface::Media.connection_type, null: false do
    description 'List trending media on Kitsu'
    argument :medium, String, required: true
  end

  def global_trending(medium:)
    raise GraphQL::ExecutionError, 'Unknown medium' unless %w[Anime Manga].include?(medium)

    TrendingService.new(medium.safe_constantize, token: context[:token]).get(10)
  end

  field :local_trending, Types::Interface::Media.connection_type, null: false do
    description 'List trending media within your network'
    argument :medium, String, required: true
  end

  def local_trending(medium:)
    raise GraphQL::ExecutionError, 'Unknown medium' unless %w[Anime Manga].include?(medium)
    return [] unless context[:user]

    TrendingService.new(medium.safe_constantize, token: context[:token]).get_network(10)
  end

  field :find_profile_by_id, Types::Profile, null: true do
    description 'Find a single User by ID'
    argument :id, ID, required: true
  end

  def find_profile_by_id(id: nil)
    ::User.find_by(id: id)
  end

  field :find_profile_by_slug, Types::Profile, null: true do
    description 'Find a single User by Slug'
    argument :slug, String, required: true
  end

  def find_profile_by_slug(slug:)
    ::User.find_by(slug: slug)
  end

  field :find_character_by_id, Types::Character, null: true do
    description 'Find a single Character by ID'
    argument :id, ID, required: true
  end

  def find_character_by_id(id:)
    ::Character.find_by(id: id)
  end

  field :find_character_by_slug, Types::Character, null: true do
    description 'Find a single Character by Slug'
    argument :slug, String, required: true
  end

  def find_character_by_slug(slug:)
    ::Character.find_by(slug: slug)
  end

  field :session, Types::Session,
    null: false,
    description: 'Get your current session info'

  def session
    context[:user] || {}
  end

  field :patrons, Types::Profile.connection_type, null: false do
    description 'Patrons sorted by a Proprietary Magic Algorithm'
  end

  def patrons
    User.patron.followed_first(context[:user]).order(followers_count: :desc)
  end

  field :find_category_by_id, Types::Category, null: true do
    description 'Find a single Category by ID'
    argument :id, ID, required: true
  end

  def find_category_by_id(id:)
    ::Category.find_by(id: id)
  end

  field :find_category_by_slug, Types::Category, null: true do
    description 'Find a single Category by Slug'
    argument :slug, String, required: true
  end

  def find_category_by_slug(slug:)
    ::Category.find_by(slug: slug)
  end

  field :lookup_mapping, Types::Union::MappingItem, null: true do
    description 'Find a specific Mapping Item by External ID and External Site.'
    argument :external_id, ID, required: true
    argument :external_site, Types::Enum::MappingExternalSite, required: true
  end

  def lookup_mapping(external_id:, external_site:)
    ::Mapping.lookup(external_site, external_id)
  end

  field :find_person_by_id, Types::Person, null: true do
    description 'Find a single Person by ID'
    argument :id, ID, required: true
  end

  def find_person_by_id(id:)
    ::Person.find_by(id: id)
  end

  field :find_person_by_slug, Types::Person, null: true do
    description 'Find a single Person by Slug'
    argument :slug, String, required: true
  end

  def find_person_by_slug(slug:)
    ::Person.find_by(slug: slug)
  end

  field :find_library_entry_by_id, Types::LibraryEntry, null: true do
    description ' Find a single Library Entry by ID'
    argument :id, ID, required: true
  end

  def find_library_entry_by_id(id:)
    ::LibraryEntry.find_by(id: id)
  end
end
