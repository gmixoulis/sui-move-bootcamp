module package_upgrade::my_module {
    use sui::balance::{Self, Balance};
    use sui::coin::Coin;
    use sui::sui::SUI;

    // @0xaaaaa::my_module::SharedBalancePool
    public struct SharedBalancePool has key {
        id: UID,
        balance: Balance<SUI>,
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(SharedBalancePool {
            id: object::new(ctx),
            balance: balance::zero(),
        });
    }

    // @aaaaaa::my_module::important_function
    public fun important_function(pool: &mut SharedBalancePool): Coin<SUI> {
        std::debug::print(&pool.balance);
        // Buggy code means the pool is exploitable
        // Buggy code means the pool is exploitable
        // Buggy code means the pool is exploitable
        // Buggy code means the pool is exploitable
        abort(0)
    }
}

// Imagine my_module as module name. We just use a different one to appease the compiler.
module package_upgrade::same_my_module {
    use sui::balance::Balance;
    use sui::coin::Coin;
    use sui::sui::SUI;

    // @0xaaaaa::my_module::SharedBalancePool
    public struct SharedBalancePool has key {
        id: UID,
        balance: Balance<SUI>,
    }

    // @bbbbbb::my_module::important_function
    public fun important_function(pool: &mut SharedBalancePool): Coin<SUI> {
        std::debug::print(&pool.balance);
        // Code without the bug
        // Code without the bug
        // Code without the bug
        // Code without the bug
        abort(0)
    }
}
