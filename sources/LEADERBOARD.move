module hema_addr ::Leaderboard {
    use aptos_framework::signer;
    use std::string::String;

    /// Struct representing a single player's score
    struct PlayerScore has store, key, drop {
        player_name: String,
        score: u64,
    }

    /// Struct representing the leaderboard statistics
    struct LeaderboardStats has store, key {
        total_players: u64,
        highest_score: u64,
    }

    /// Function to initialize the leaderboard statistics
    public fun initialize_leaderboard(owner: &signer) {
        let stats = LeaderboardStats {
            total_players: 0,
            highest_score: 0,
        };
        move_to(owner, stats);
    }

    /// Function to register or update a player's score
    public fun register_score(
        player: &signer,
        leaderboard_owner: address,
        player_name: String,
        new_score: u64
    ) acquires LeaderboardStats, PlayerScore {
        let player_addr = signer::address_of(player);
        
        // Update leaderboard statistics
        let stats = borrow_global_mut<LeaderboardStats>(leaderboard_owner);
        
        // Check if player already has a score registered
        if (!exists<PlayerScore>(player_addr)) {
            stats.total_players = stats.total_players + 1;
        };
        
        // Update highest score if needed
        if (new_score > stats.highest_score) {
            stats.highest_score = new_score;
        };
        
        // Create or update player's score
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