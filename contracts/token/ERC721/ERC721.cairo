%lang starknet
%builtins pedersen range_check ecdsa

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, uint256_sub)

from contracts.token.ERC721.ERC721_base import (
    ERC721_name, ERC721_symbol, ERC721_balanceOf, ERC721_ownerOf, ERC721_getApproved,
    ERC721_isApprovedForAll, ERC721_mint, ERC721_burn, ERC721_initializer, ERC721_approve,
    ERC721_setApprovalForAll, ERC721_transferFrom, ERC721_safeTransferFrom)



#
# Declaring storage vars
# Storage vars are by default not visible through the ABI. They are similar to "private" variables in Solidity
#

@storage_var
func sex_storage(token_id : Uint256) -> (sex: felt):
end

@storage_var
func legs_storage(token_id : Uint256) -> (legs: felt):
end

@storage_var
func wings_storage(token_id : Uint256) -> (wings: felt):
end

@storage_var
func token_counter_storage() -> (token_counter: felt):
end

@storage_var
func evaluator_address_storage() -> (evaluator_address: felt):
end

@storage_var
func token_of_owner_by_index_storage(account : felt, index : felt) -> (token_id : Uint256):
end


#
# Getters
#

@view
func token_of_owner_by_index{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(account : felt, index : felt) -> (token_id : Uint256):
    let (token_id) = token_of_owner_by_index_storage.read(account, index)
    return (token_id)
end

# Useless for now
@view
func get_sex_of{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(token_id : Uint256) -> (sex : felt):
    let (sex) = sex_storage.read(token_id)
    return (sex)
end

# Useless for now
@view
func get_legs_of{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(token_id : Uint256) -> (legs : felt):
    let (legs) = legs_storage.read(token_id)
    return (legs)
end

# Useless for now
@view
func get_wings_of{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(token_id : Uint256) -> (wings : felt):
    let (wings) = wings_storage.read(token_id)
    return (wings)
end

@view
func get_token_counter{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (token_counter : felt):
    let (token_counter) = token_counter_storage.read()
    return (token_counter)
end

@view
func get_evaluator_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (evaluator_address : felt):
    let (evaluator_address) = evaluator_address_storage.read()
    return (evaluator_address)
end

@view
func get_animal_characteristics{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(token_id : Uint256) -> (sex : felt, legs : felt, wings : felt):
    let (sex) = sex_storage.read(token_id)
    let (legs) = legs_storage.read(token_id)
    let (wings) = wings_storage.read(token_id)
    return (sex = sex, legs = legs, wings = wings)
end

@view
func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (name : felt):
    let (name) = ERC721_name()
    return (name)
end

@view
func symbol{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (symbol : felt):
    let (symbol) = ERC721_symbol()
    return (symbol)
end

@view
func balanceOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(owner : felt) -> (
        balance : Uint256):
    let (balance : Uint256) = ERC721_balanceOf(owner)
    return (balance)
end

@view
func ownerOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        token_id : Uint256) -> (owner : felt):
    let (owner : felt) = ERC721_ownerOf(token_id)
    return (owner)
end

@view
func getApproved{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        token_id : Uint256) -> (approved : felt):
    let (approved : felt) = ERC721_getApproved(token_id)
    return (approved)
end

@view
func isApprovedForAll{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt, operator : felt) -> (is_approved : felt):
    let (is_approved : felt) = ERC721_isApprovedForAll(owner, operator)
    return (is_approved)
end

#
# Externals
#

@external
func approve{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
        to : felt, token_id : Uint256):
    ERC721_approve(to, token_id)
    return ()
end

@external
func setApprovalForAll{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        operator : felt, approved : felt):
    ERC721_setApprovalForAll(operator, approved)
    return ()
end

@external
func transferFrom{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
        _from : felt, to : felt, token_id : Uint256):
    ERC721_transferFrom(_from, to, token_id)
    return ()
end

@external
func safeTransferFrom{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
        _from : felt, to : felt, token_id : Uint256, data_len : felt, data : felt*):
    ERC721_safeTransferFrom(_from, to, token_id, data_len, data)
    return ()
end

#Temporary solution until to find how to handle Uint256
@external 
func declare_animal{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(sex : felt, legs : felt, wings : felt) -> (token_id : Uint256):
    alloc_locals
    let ( token_counter ) = token_counter_storage.read()
    let token_id : Uint256 = Uint256(token_counter + 1, 0)
    token_counter_storage.write(token_counter + 1)
    let (to) = evaluator_address_storage.read()
    let (balanceOfOwner) = balanceOf(to)
    token_of_owner_by_index_storage.write(to, balanceOfOwner.low, token_id)
    ERC721_mint(to, token_id)
    sex_storage.write(token_id, sex)
    legs_storage.write(token_id, legs)
    wings_storage.write(token_id, wings)
    return ( token_id )
end


@external
func declare_dead_animal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(token_id : Uint256):
    sex_storage.write(token_id, 0)
    legs_storage.write(token_id, 0)
    wings_storage.write(token_id, 0)
    ERC721_burn(token_id)
    return ()
end

#
# Constructor
#

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        name : felt, symbol : felt, to_ : felt):
    ERC721_initializer(name, symbol)
    let to = to_
    let token_id : Uint256 = Uint256(1, 0)
    ERC721_mint(to, token_id)
    token_counter_storage.write(1)
    evaluator_address_storage.write(to)
    sex_storage.write(token_id, 2)
    legs_storage.write(token_id, 7)
    wings_storage.write(token_id, 2)
    token_of_owner_by_index_storage.write(to, 0, token_id)
    return ()
end

