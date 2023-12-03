import heapq as hq

ROOMS = {
    "A": 2,
    "B": 4,
    "C": 6,
    "D": 8
}

COSTS = {
    "A": 1,
    "B": 10,
    "C": 100,
    "D": 1000
}

GOAL1 = (
    ("A", "A"), ("B", "B"), ("C", "C"), ("D", "D")
)

GOAL2 = (
    ("A", "A", "A", "A"),
    ("B", "B", "B", "B"),
    ("C", "C", "C", "C"),
    ("D", "D", "D", "D")
)

def dijkstra(start, GOAL):
    q = [
        (0, 0, (start, (None, None, None, None, None, None, None, None, None, None, None)))
    ]
    hq.heapify(q)

    seen = set()
    while len(q):
        cost, _, (rooms, hallway) = hq.heappop(q)
        if rooms == GOAL:
            return cost

        # Already been here?
        if (rooms, hallway) in seen:
            continue
        seen.add((rooms, hallway))

        # Move an amphipod from a room into the hallway.
        for i, room in enumerate(rooms):
            # If we're done this room, then don't bother.
            if room == GOAL[i]:
                continue

            # We can only move the first amphipod in each room, the others are
            # "stuck."
            try:
                j, c = next((j, c) for j, c in enumerate(room) if c)
            except StopIteration:
                continue

            for p in [0, 1, 3, 5, 7, 9, 10]:
                # Check if path is obstructed.
                if all(
                    z is None
                        for z in hallway[min(2*i + 2, p):max(2*i + 2, p) + 1]
                ):
                    _cost = cost + COSTS[c]*(j + abs(2*i + 2 - p) + 1)
                    _rooms = tuple(
                        tuple(
                            None if (k == i and l == j) else c
                                for l, c in enumerate(room)
                        )
                            for k, room in enumerate(rooms)
                    )
                    _hallway = tuple(
                        c if k == p else h
                            for k, h in enumerate(hallway)
                    )
                    
                    hq.heappush(
                        q, (_cost, id(_rooms), (_rooms, _hallway))
                    )                     

        # Move an amphibian from the hallway into their room.
        for p in [0, 1, 3, 5, 7, 9, 10]:
            c = hallway[p]
            if c is None:
                continue

            # Check if path is obstructed.
            path = hallway[ROOMS[c]:p] if p > ROOMS[c] else hallway[p + 1:ROOMS[c] + 1]
            if all(
                z is None for z in path
            ):
                i = ord(c) - ord('A')
                room = rooms[i]

                # When we enter a room, we want to go as far back as possible.
                if all(
                    z in {None, c} for z in room
                ):
                    j = 0
                    while j < len(room) and room[j] is None:
                        j = j + 1
                    j = j - 1

                    if room[j] is not None:
                        continue

                    _cost = cost + COSTS[c]*(j + abs(ROOMS[c] - p) + 1)
                    _rooms = tuple(
                        tuple(
                            c if (k == i and l == j) else h
                                for l, h in enumerate(room)
                        )
                            for k, room in enumerate(rooms)
                    )
                    _hallway = tuple(
                        None if k == p else h
                            for k, h in enumerate(hallway)
                    )

                    hq.heappush(
                        q, (_cost, id(_rooms), (_rooms, _hallway))
                    )                     

rooms = (
    ("A", "D"),
    ("C", "D"),
    ("B", "A"),
    ("B", "C")
)

print(dijkstra(rooms, GOAL1))

rooms = (
    ("A", "D", "D", "D"),
    ("C", "C", "B", "D"),
    ("B", "B", "A", "A"),
    ("B", "A", "C", "C")
)

print(dijkstra(rooms, GOAL2))