require 'spec_helper'
require 'player'

feature "players start a fight by entering their names and seeing them", :type => :feature do

  scenario "user enters name and sees it appear on screen" do
    sign_in_and_play
    expect(page).to have_content("Kat vs. Bob")
  end

end

feature "players can see each other's hit points" do

  scenario "hit points are visible" do
    sign_in_and_play
    expect(page).to have_selector("//p", id: "hit_points_id")
  end

  scenario "player one can see the phrase 'HP'" do
    # same test as above but with alternative syntax
    sign_in_and_play
    within("div#player_two_id") { expect(page).to have_content("HP") }
  end

end

feature "players can attack each other and get a confirmation" do

  scenario "attack button is available" do
    sign_in_and_play
    expect(page).to have_selector("//input", id: "attack_button_id")
  end

  scenario "first player gets confirmation after attack" do
    sign_in_and_play
    click_button "Attack"
    expect(page).to have_content("Kat attacked Bob")
  end

  scenario "second player gets confirmation after attack" do
    sign_in_and_play
    attack_and_confirm
    click_button "Attack"
    expect(page).to have_content("Bob attacked Kat")
  end

end

feature "when player 1 attacks, player 2 should lose 10 hit points" do

  scenario "both players should start with 60 hit points" do
    sign_in_and_play
    within("div#player_two_id") { expect(page).to have_content("60") }
  end

  scenario "player 2 loses 10 hit points after attack" do
    sign_in_and_play
    attack_and_confirm
    within("div#player_two_id") { expect(page).to have_content("50") }
  end

end

feature "when player 2 attacks, player 1 should lose 10 hit points" do

  scenario "both players should start with 60 hit points" do
    sign_in_and_play
    within("div#player_one_id") { expect(page).to have_content("60") }
  end

  scenario "player 1 loses 10 hit points after attack" do
    sign_in_and_play
    attack_and_confirm
    attack_and_confirm
    within("div#player_one_id") { expect(page).to have_content("50") }
  end

end

feature "players switching turns" do

  scenario "game starts with player 1's turn" do
    sign_in_and_play
    expect(page).to have_content("It's Kat's turn!")
  end

  scenario "switches to player 2's turn after attack" do
    sign_in_and_play
    attack_and_confirm
    expect(page).to have_content("It's Bob's turn!")
  end

end

feature "players can lose" do

  scenario "if a player's score reaches 0HP, they lose" do
    play_through = ((Player::INITIAL_HP / 10) - 1) * 2

    sign_in_and_play
    play_through.times { attack_and_confirm }
    click_button "Attack"

    expect(page).to have_content("Bob, you lose!")
  end

end
