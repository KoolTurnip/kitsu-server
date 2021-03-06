class Types::MediaReaction < Types::BaseObject
  description 'A simple review that is 140 characters long expressing how you felt about a media'

  field :id, ID, null: false

  field :author, Types::Profile,
    null: false,
    description: 'The author who wrote this reaction.',
    method: :user

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media related to this reaction.'

  field :library_entry, Types::LibraryEntry,
    null: false,
    description: 'The library entry related to this reaction.'

  field :progress, Integer,
    null: false,
    description: 'When this media reaction was written based on media progress.'

  field :reaction, String,
    null: false,
    description: 'The reaction text related to a media.'

  field :likes, Types::Profile.connection_type,
    null: false,
    description: 'Users who liked this reaction.'

  def likes
    AssociationLoader.for(object.class, :votes, policy: :media_reaction_vote)
                     .scope(object).then do |likes|
      RecordLoader.for(User).load_many(likes.pluck(:user_id))
    end
  end
end
