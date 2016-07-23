defmodule Changelog.EpisodeControllerTest do
  use Changelog.ConnCase

  test "getting a published podcast episode page" do
    p = insert(:podcast)
    e = insert(:published_episode, podcast: p)
    conn = get(build_conn, episode_path(build_conn, :show, p.slug, e.slug))
    assert html_response(conn, 200) =~ e.title
  end

  test "getting a podcast episode page that is not published" do
    p = insert(:podcast)
    e = insert(:episode, podcast: p)

    assert_raise Ecto.NoResultsError, fn ->
      get(build_conn, episode_path(build_conn, :show, p.slug, e.slug))
    end
  end

  test "geting a podcast episode page that doesn't exist" do
    p = insert(:podcast)

    assert_raise Ecto.NoResultsError, fn ->
      get(build_conn, episode_path(build_conn, :show, p.slug, "bad-episode"))
    end
  end

  test "previewing a podcast episode when not an admin" do
    p = insert(:podcast)
    e = insert(:episode, podcast: p)

    conn = get(build_conn, episode_path(build_conn, :preview, p.slug, e.slug))
    assert conn.halted
  end

  @tag :as_admin
  test "previewing a podcast episode when signed in as admin", %{conn: conn} do
    p = insert(:podcast)
    e = insert(:episode, podcast: p)

    conn = get(conn, episode_path(conn, :preview, p.slug, e.slug))
    assert html_response(conn, 200) =~ e.title
  end
end
