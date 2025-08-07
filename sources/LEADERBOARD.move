module hema_addr ::Leaderboard {
    use aptos_framework::signer;
    use std::string::String;

    struct PlayerScore has store, key, drop {
        player_name: String,
        score: u64,
    }

    struct LeaderboardStats has store, key {
        total_players: u64,
        highest_score: u64,
    }

  
    public fun initialize_leaderboard(owner: &signer) {
        let stats = LeaderboardStats {
            total_players: 0,
            highest_score: 0,
        };
        move_to(owner, stats);
    }

    public fun register_score(
        player: &signer,
        leaderboard_owner: address,
        player_name: String,
        new_score: u64
    ) acquires LeaderboardStats, PlayerScore {
        let player_addr = signer::address_of(player);
        
        let stats = borrow_global_mut<LeaderboardStats>(leaderboard_owner);
        
        
        if (!exists<PlayerScore>(player_addr)) {
            stats.total_players = stats.total_players + 1;
        };
        
        if (new_score > stats.highest_score) {
            stats.highest_score = new_score;
        };
        
        let player_score = PlayerScore {
            player_name,
            score: new_score,
        };
        
        if (exists<PlayerScore>(player_addr)) {
            let old_score = move_from<PlayerScore>(player_addr);
            move_to(player, player_score);
        } else {
            move_to(player, player_score);
        };
    }

}
