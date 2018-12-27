module Day24
export part1, part2, puzzle

using Lazy
using DataStructures
using AOC

mutable struct Group
    id     :: Int64
    army   :: Int64
    units  :: Int64
    hp     :: Int64
    atk    :: Int64
    typ    :: Int64
    ini    :: Int64
    weak   :: Array{Int64, 1}
    immune :: Array{Int64, 1}
end

function readInput(name)
    army = 0
    armies = Group[]
    id = 0

    types = Dict{String, Int64}()
    nTypes = 0
    idType(name) = let id = get(types, String(name), 0)
        if id == 0
            nTypes += 1
            types[name] = nTypes
        else
            id
        end
    end

    foreach(eachline(name)) do l
        if startswith(l, "Immune System")
            army = 1
        elseif startswith(l, "Infection")
            army = 2
        elseif (m=match(r"(\d+) units each with (\d+) hit points(.*) with an attack that does (\d+) (.*) damage at initiative (\d+)", l)) !== nothing
            (units, hp, special, atk, typ, ini) = m.captures
            (units, hp, atk, ini) = toInt.((units, hp, atk, ini))

            weak = (m=match(r"weak to ([^;)]+)", special)) !== nothing ?
                [idType(name) for name in split(m.captures[1], ", ")] :
                []

            immune = (m=match(r"immune to ([^;)]+)", special)) !== nothing ?
                [idType(name) for name in split(m.captures[1], ", ")] :
                []

            id += 1
            g = Group(id, army, units, hp, atk, idType(typ), ini, weak, immune)
            push!(armies, g)
            @assert g.id == length(armies)
        end
    end
    (armies, id)
end

function damage(armies, targets, atk, idDef)
    def = @inbounds armies[idDef]
    def.army == atk.army  && return (0,0,0,0)
    idDef   in targets    && return (0,0,0,0)
    atk.typ in def.immune && return (0,0,0,0)
    def.units == 0        && return (0,0,0,0)

    dmg = atk.units*atk.atk
    if atk.typ in def.weak
        dmg *= 2
    end

    (dmg,
     def.units*def.atk,
     def.ini,
     idDef)
end

function battle(armies, N)
    attacks = Dict{Int, Int}()
    targets = Int[]

    k = 0
    units_last = (0,0)
    while true
        k += 1
        units = reduce((a,b)->a.+b,
                       (g.army==1 ? (g.units,0) : (0,g.units)
                        for g in values(armies)))
        units == units_last && return units
        any(x->x==0, units) && return units
        units_last = units

        # Target selection
        for idAtk in sort(1:N; by=id -> let g = @inbounds armies[id]
                          (-g.units*g.atk, -g.ini)
                          end)
            atk = armies[idAtk]
            attacks[idAtk] = 0
            atk.units == 0 && continue

            m = (0,0,0,0)
            for idDef in 1:N
                dmg = damage(armies, targets, atk, idDef)
                m = max(m, dmg)
            end
            (dmg,_,_,idDef) = m

            if dmg > 0
                push!(targets, idDef)
                attacks[idAtk] = idDef
            end
        end

        # Attacking phase
        empty!(targets)
        for idAtk in sort(1:N; by=id -> -armies[id].ini)
            atk = armies[idAtk]
            (idDef = attacks[idAtk]) == 0 && continue

            (dmg,_,_,_) = damage(armies, targets, atk, idDef)
            def = armies[idDef]
            kills = min(div(dmg, def.hp), def.units)
            def.units -= kills
        end
    end
end

function part1()
    (armies, N) = readInput("input24")
    battle(armies, N) |> maximum
end

function part2()
    (armies_orig, N) = readInput("input24")

    for boost in 1:2000
        armies = deepcopy(armies_orig)
        for g in values(armies)
            if g.army == 1
                g.atk += boost
            end
        end
        units = battle(armies, N)
        units[1] != 0 && units[2] == 0 && return units[1]
    end
end

end # module
