defmodule ChangelogStatsTest do
  use Changelog.ModelCase

  alias Changelog.Stats

  # TODO need some kind of mocking/expectation solution to test this right
  describe "process" do
    @tag :skip
    test "when just given a date, it processes all published podcasts" do
      insert(:podcast)
      insert(:podcast)
      Stats.process(Timex.today)
    end

    @tag :skip
    test "when given a date and list of podcasts, it processes them" do
      podcast1 = insert(:podcast)
      podcast2 = insert(:podcast)
      Stats.process(Timex.today, [podcast1, podcast2])
    end

    test "it processes known logs from 2016-10-10" do
      podcast = insert(:podcast)

      e1 = insert(:episode, podcast: podcast, slug: "223", bytes: 80743303)

      stats = Stats.process(~D[2016-10-10], podcast)
      assert length(stats) == 1
      stat = get_stat(stats, e1)
      assert stat.downloads == 1.83
    end

    test "it processes known logs from 2016-10-11" do
      podcast = insert(:podcast)

      e1 = insert(:episode, podcast: podcast, slug: "114", bytes: 26238621)
      e2 = insert(:episode, podcast: podcast, slug: "181", bytes: 59310792)
      e3 = insert(:episode, podcast: podcast, slug: "182", bytes: 56304828)
      e4 = insert(:episode, podcast: podcast, slug: "183", bytes: 63723737)
      e5 = insert(:episode, podcast: podcast, slug: "202", bytes: 79743350)
      e6 = insert(:episode, podcast: podcast, slug: "204", bytes: 70867090)
      e7 = insert(:episode, podcast: podcast, slug: "205", bytes: 112042496)
      e8 = insert(:episode, podcast: podcast, slug: "207", bytes: 77737571)
      e9 = insert(:episode, podcast: podcast, slug: "216", bytes: 81286241)
      e10 = insert(:episode, podcast: podcast, slug: "217", bytes: 86659297)
      e11 = insert(:episode, podcast: podcast, slug: "218", bytes: 84495463)
      e12 = insert(:episode, podcast: podcast, slug: "219", bytes: 62733067)
      e13 = insert(:episode, podcast: podcast, slug: "220", bytes: 87270178)
      e14 = insert(:episode, podcast: podcast, slug: "221", bytes: 77652463)
      e15 = insert(:episode, podcast: podcast, slug: "222", bytes: 81563934)
      e16 = insert(:episode, podcast: podcast, slug: "223", bytes: 80743303)

      stats = Stats.process(~D[2016-10-11], podcast)
      assert length(stats) == 16

      stat = get_stat(stats, e1)
      assert stat.downloads == 1

      stat = get_stat(stats, e2)
      assert stat.downloads == 1.06

      stat = get_stat(stats, e3)
      assert stat.downloads == 0.04

      stat = get_stat(stats, e4)
      assert stat.downloads == 3.2

      stat = get_stat(stats, e5)
      assert stat.downloads == 2

      stat = get_stat(stats, e6)
      assert stat.downloads == 1

      stat = get_stat(stats, e7)
      assert stat.downloads == 1

      stat = get_stat(stats, e8)
      assert stat.downloads == 2

      stat = get_stat(stats, e9)
      assert stat.downloads == 2

      stat = get_stat(stats, e10)
      assert stat.downloads == 2.84

      stat = get_stat(stats, e11)
      assert stat.downloads == 2.89

      stat = get_stat(stats, e12)
      assert stat.downloads == 1

      stat = get_stat(stats, e13)
      assert stat.downloads == 4.22

      stat = get_stat(stats, e14)
      assert stat.downloads == 1

      stat = get_stat(stats, e15)
      assert stat.downloads == 5.73

      stat = get_stat(stats, e16)
      assert stat.downloads == 10.18
    end

    defp get_stat(stats, episode) do
      Enum.find(stats, fn(x) -> x.episode_id == episode.id end)
    end
  end
end
