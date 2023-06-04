// cairo-lang-starknet 1.0.0
use starknet::ContractAddress;

#[abi]
trait IERC20 {
    fn approve(spender: ContractAddress, amount: u256) -> bool;
    fn mint(amount: u256);
    fn transfer(recipient: ContractAddress, amount: u256) -> bool;
    fn transferFrom(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;
    fn balanceOf(account: ContractAddress) -> u256;
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;
}

#[contract]
mod challenge4 {

    use integer::u256_from_felt252;
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::get_contract_address;
    use super::IERC20Dispatcher;
    use super::IERC20DispatcherTrait;

    // const L2_TOKEN_ADDRESS: ContractAddress = 0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7;

    struct Storage {
        _l2_token_address: ContractAddress,
        _complete: bool,
        _answer: felt252,
    }

    #[[constructor]
    fn constructor(l2_token_address: ContractAddress) {
        _complete::write(false);
        _answer::write(42);
        _l2_token_address::write(l2_token_address);
    }

    #[external]
    fn guess(n: felt252) {
        let contractAddress =  get_contract_address();
        let l2_token = IERC20Dispatcher { contract_address: _l2_token_address::read() };
        let balance: u256 = l2_token.balanceOf(contractAddress);
        let amount = u256_from_felt252(10000000000000000);

        assert(balance == amount, 'Deposit required');

        let number = _answer::read();
        assert(n == number, 'Incorrect guessed number.');

        let sender=get_caller_address();
        l2_token.transfer(sender, amount);
        _complete::write(true);


    }

    #[view]
    fn isComplete () -> bool {
        return _complete::read();
    }
}
