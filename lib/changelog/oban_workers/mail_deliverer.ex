defmodule Changelog.ObanWorkers.MailDeliverer do
  @moduledoc """
  This module defines the Oban worker for delivering all email. We no longer use
  Bamboo's `deliver_later/1` function directly, using Oban instead.
  """
  use Oban.Worker, queue: :email, unique: [fields: [:args, :queue], period: 60]

  alias Changelog.{Episode, EpisodeGuest, EpisodeRequest, Mailer, NewsItem,
    NewsItemComment, Newsletters, Person, Podcast, Repo, Subscription}

  alias ChangelogWeb.Email

  @impl Oban.Worker
  def perform(%Oban.Job{args: args = %{"mailer" => mailer}}) do
    apply(__MODULE__, String.to_existing_atom(mailer), [args])

    :ok
  end

  def enqueue(mailer, args) do
    %{"mailer" => mailer}
    |> Map.merge(args)
    |> new()
    |> Oban.insert()
  end

  def authored_news_published(%{"item" => id}) do
    NewsItem
    |> Repo.get(id)
    |> NewsItem.preload_all()
    |> Email.authored_news_published()
    |> Mailer.deliver_now()
  end

  def community_welcome(%{"person" => id}) do
    Person
    |> Repo.get(id)
    |> Email.community_welcome()
    |> Mailer.deliver_now()
  end

  def submitted_news_published(%{"item" => id}) do
    NewsItem
    |> Repo.get(id)
    |> NewsItem.preload_all()
    |> Email.submitted_news_published()
    |> Mailer.deliver_now()
  end

  def submitted_news_declined(%{"item" => id}) do
    NewsItem
    |> Repo.get(id)
    |> NewsItem.preload_all()
    |> Email.submitted_news_declined()
    |> Mailer.deliver_now()
  end

  def comment_approval(%{"person" => p_id, "comment" => c_id}) do
    comment = NewsItemComment |> Repo.get(c_id) |> NewsItemComment.preload_all()

    Person
    |> Repo.get(p_id)
    |> Email.comment_approval(comment)
    |> Mailer.deliver_now()
  end

  def comment_mention(%{"person" => p_id, "comment" => c_id}) do
    comment = NewsItemComment |> Repo.get(c_id) |> NewsItemComment.preload_all()

    Person
    |> Repo.get(p_id)
    |> Email.comment_mention(comment)
    |> Mailer.deliver_now()
  end

  def comment_reply(%{"person" => p_id, "comment" => c_id}) do
    comment = NewsItemComment |> Repo.get(c_id) |> NewsItemComment.preload_all()

    Person
    |> Repo.get(p_id)
    |> Email.comment_reply(comment)
    |> Mailer.deliver_now()
  end

  # This is an edge case where we're actually storing the subscription id as "person"
  def comment_subscription(%{"person" => p_id, "comment" => c_id}) do
    comment = NewsItemComment |> Repo.get(c_id) |> NewsItemComment.preload_all()

    Subscription
    |> Repo.get(p_id)
    |> Subscription.preload_all()
    |> Email.comment_subscription(comment)
    |> Mailer.deliver_now()
  end

  def guest_thanks(%{"episode_guest" => eg_id}) do
    EpisodeGuest
    |> Repo.get(eg_id)
    |> Email.guest_thanks()
    |> Mailer.deliver_now()
  end

  def guest_welcome(%{"person" => id}) do
    Person
    |> Repo.get(id)
    |> Email.guest_welcome()
    |> Mailer.deliver_now()
  end

  def episode_published(%{"subscription" => s_id, "episode" => e_id}) do
    episode = Episode |> Repo.get(e_id) |> Episode.preload_all()

    Subscription
    |> Repo.get(s_id)
    |> Subscription.preload_all()
    |> Email.episode_published(episode)
    |> Mailer.deliver_now()
  end

  def episode_transcribed(%{"person" => p_id, "episode" => e_id}) do
    episode = Episode |> Repo.get(e_id) |> Episode.preload_all()

    Person
    |> Repo.get(p_id)
    |> Email.episode_transcribed(episode)
    |> Mailer.deliver_now()
  end

  def episode_request_declined(%{"request" => id}) do
    EpisodeRequest
    |> Repo.get(id)
    |> EpisodeRequest.preload_all()
    |> Email.episode_request_declined()
    |> Mailer.deliver_now()
  end

  def episode_request_failed(%{"request" => id}) do
    EpisodeRequest
    |> Repo.get(id)
    |> EpisodeRequest.preload_all()
    |> Email.episode_request_failed()
    |> Mailer.deliver_now()
  end

  def episode_request_published(%{"request" => id}) do
    EpisodeRequest
    |> Repo.get(id)
    |> EpisodeRequest.preload_all()
    |> Email.episode_request_published()
    |> Mailer.deliver_now()
  end

  def sign_in(%{"person" => id}) do
    Person
    |> Repo.get(id)
    |> Email.sign_in()
    |> Mailer.deliver_now()
  end

  def subscriber_welcome(%{"person" => id, "newsletter" => slug}) do
    newsletter = Newsletters.get_by_slug(slug)

    Person
    |> Repo.get(id)
    |> Email.subscriber_welcome(newsletter)
    |> Mailer.deliver_now()
  end

  def subscriber_welcome(%{"person" => id, "podcast" => slug}) do
    podcast = Podcast.get_by_slug!(slug)

    Person
    |> Repo.get(id)
    |> Email.subscriber_welcome(podcast)
    |> Mailer.deliver_now()
  end
end
