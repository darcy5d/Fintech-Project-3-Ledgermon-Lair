// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ledgermon.sol";

// Inherit from the Pokemon contract
contract LedgermonBattle is Ledgermon {
    // Enum to represent the state of a battle
    enum BattleState { NotStarted, Player1Turn, Player2Turn, Ended }

    // Struct to represent a battle
    struct Battle {
        uint256 battleId;
        address player1;
        address player2;
        PokemonAttributes player1Pokemon;
        PokemonAttributes player2Pokemon;
        BattleState state;
        address turn;
        address winner;
        uint256 opponentPokemonId; // New member to store the opponent's Pokemon ID
    }

    // Public variable to track the next battle ID
    uint256 public nextBattleId;

    // Mapping to store battles by their ID
    mapping(uint256 => Battle) public battles;

    // Event emitted when a battle is initiated
    event BattleInitiated(uint256 indexed battleId, address indexed player1, address indexed player2);

    // Event emitted when a turn is taken in a battle
    event TurnTaken(uint256 indexed battleId, address indexed player, PokemonAttributes playerPokemon, PokemonAttributes opponentPokemon, bool playerWins);

    // Event emitted when a battle ends
    event BattleEnded(uint256 indexed battleId, address indexed winner);

    // Modifier to ensure that the caller is a participant in the specified battle
    modifier onlyParticipants(uint256 battleId) {
        require(msg.sender == battles[battleId].player1 || msg.sender == battles[battleId].player2, "You are not a participant in this battle");
        _;
    }

    // Modifier to ensure that it's the caller's turn in the specified battle
    modifier isPlayersTurn(uint256 battleId) {
        require(msg.sender == battles[battleId].turn, "It's not your turn");
        _;
    }

    // Modifier to ensure that the battle is not ended
    modifier battleNotEnded(uint256 battleId) {
        require(battles[battleId].state != BattleState.Ended, "Battle has already ended");
        _;
    }

    // Function to initiate a battle between the caller and an opponent
    function initiateBattle(address opponent, uint8 tokenIdOpponent, uint8 tokenIdOwner) external {
        require(balanceOf(msg.sender) > 0, "You need at least one Pokemon to start a battle");
        require(balanceOf(opponent) > 0, "Your opponent needs at least one Pokemon to start a battle");

        // Create a new battle ID and get the next two token IDs
        uint256 battleId = nextBattleId++;

        // Initialize player1 and player2 Pokemon attributes
        battles[battleId] = Battle({
            battleId: battleId,
            player1: msg.sender,
            player2: opponent,
            player1Pokemon: PokemonAttributes({ tokenId: tokenIdOpponent, attack: 0, defense: 0, speed: 0, level: 0}),
            player2Pokemon: PokemonAttributes({ tokenId: tokenIdOwner, attack: 0, defense: 0, speed: 0, level: 0 }),
            state: BattleState.Player1Turn,
            turn: msg.sender,
            winner: address(0),
            opponentPokemonId: tokenIdOpponent // Assign the opponent's Pokemon ID
        });

        // Emit an event to indicate that the battle has been initiated
        emit BattleInitiated(battleId, msg.sender, opponent);
    }

    // Function for a player to take their turn in the battle
    function takeTurn(uint256 battleId) external onlyParticipants(battleId) isPlayersTurn(battleId) battleNotEnded(battleId) {
        // Determine which player is taking the turn and assign relevant variables
        address winner;
        address loser;

        // Determine which player is taking the turn
        if (msg.sender == battles[battleId].player1) {
            winner = battles[battleId].player1;
            loser = battles[battleId].player2;
        } else {
            winner = battles[battleId].player2;
            loser = battles[battleId].player1;
        }

        // Basic attack calculation: attacker's attack minus defender's defense with random multipliers
        uint256 blockDifficulty = block.difficulty;

        // Get the last digit
        uint256 rand_1 = blockDifficulty % 10;
        uint256 rand_2 = (blockDifficulty / 10) % 10;
        uint256 damage = battles[battleId].player1Pokemon.attack + rand_1 > battles[battleId].player2Pokemon.defense + rand_2 ? battles[battleId].player1Pokemon.attack - battles[battleId].player2Pokemon.defense : 0;

        // Reduce defender's HP
        if (battles[battleId].player2Pokemon.defense > damage) {
            battles[battleId].player2Pokemon.defense -= damage;
        } else {
            // Defender fainted
            battles[battleId].player2Pokemon.defense = 0;

            // Winner gets the opponent's Pokemon
            _transfer(loser, winner, battles[battleId].opponentPokemonId);

            // Winner's Pokemon is leveled up
            battles[battleId].player1Pokemon.level++;
        }

        // Emit an event to indicate the turn has been taken
        emit TurnTaken(battleId, msg.sender, battles[battleId].player1Pokemon, battles[battleId].player2Pokemon, true);

        // Update game state to indicate the battle has ended
        battles[battleId].state = BattleState.Ended;
        battles[battleId].turn = address(0);
        battles[battleId].winner = winner;

        // Emit an event to indicate the battle has ended
        emit BattleEnded(battleId, battles[battleId].winner);
    }
}
