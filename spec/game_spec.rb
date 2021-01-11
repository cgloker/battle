require 'game'

describe Game do

  let(:stefan) { spy("Player") }
  let(:kat) { spy("Player") }
  let(:bob) { spy("Player") }

  before(:each) do
    allow(stefan).to receive(:points).and_return(60)
    allow(kat).to receive(:points).and_return(60)
    allow(bob).to receive(:points).and_return(0)
  end

  subject(:game) { described_class.new(stefan, kat) }
  subject(:lost_game) { described_class.new(stefan, bob) }


  context "#initialize" do
    it 'starts with two player objects' do
      expect(game.player_one).to eq stefan
      expect(game.player_two).to eq kat
    end
  end

  context '#attack' do
    it 'deducts points from the attacked player' do
      game.attack
      expect(kat).to have_received(:deduct_points)
    end
  end

  context '#switch_turn' do
    it 'switches the turn' do
      expect{ game.switch_turn }.to change{ game.turns[:attacker] }
      expect{ game.switch_turn }.to change{ game.turns[:attacked] }
    end
  end

  context '#game_over?' do
    it 'returns false at the beginning' do
      expect(game.game_over?).to be false
    end

    it 'returns true when a player has zero points' do
      expect(lost_game.game_over?).to be true
    end
  end

end
