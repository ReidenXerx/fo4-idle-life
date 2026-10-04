"""Idle Life 1.1.1: the grid answers must equal the old answers. Both methods, ported 1:1 from Spots.cpp, on the
real Diamond City navmesh dump (IdleLife-navmesh-walls-2.json), at many random points and heights."""
import json, math, random, time

d = json.load(open(r"C:\Users\DuduPhudu\Documents\Projects\fo4-idle-life\build\navmesh\IdleLife-navmesh-walls-2.json"))
tris = [((t[0], t[1], t[2]), (t[3], t[4], t[5]), (t[6], t[7], t[8])) for t in d["triangles"]]
borders = d["borders"]


def floor_one(t, x, y, near, within):
    a, b, c = t
    den = (b[1] - c[1]) * (a[0] - c[0]) + (c[0] - b[0]) * (a[1] - c[1])
    if abs(den) < 1e-3:
        return None
    l1 = ((b[1] - c[1]) * (x - c[0]) + (c[0] - b[0]) * (y - c[1])) / den
    l2 = ((c[1] - a[1]) * (x - c[0]) + (a[0] - c[0]) * (y - c[1])) / den
    l3 = 1 - l1 - l2
    if l1 < -1e-4 or l2 < -1e-4 or l3 < -1e-4:
        return None
    z = l1 * a[2] + l2 * b[2] + l3 * c[2]
    return z if abs(z - near) <= within else None


def floor_old(x, y, near, within):
    best = None
    for t in tris:
        z = floor_one(t, x, y, near, within)
        if z is not None and (best is None or abs(z - near) < abs(best - near)):
            best = z
    return best


CELL = 256.0
grid = {}
for i, (a, b, c) in enumerate(tris):
    for ix in range(math.floor(min(a[0], b[0], c[0]) / CELL), math.floor(max(a[0], b[0], c[0]) / CELL) + 1):
        for iy in range(math.floor(min(a[1], b[1], c[1]) / CELL), math.floor(max(a[1], b[1], c[1]) / CELL) + 1):
            grid.setdefault((ix, iy), []).append(i)


def floor_new(x, y, near, within):
    best = None
    for i in grid.get((math.floor(x / CELL), math.floor(y / CELL)), []):
        z = floor_one(tris[i], x, y, near, within)
        if z is not None and (best is None or abs(z - near) < abs(best - near)):
            best = z
    return best


def seg_dist(px, py, e):
    ax, ay, bx, by = e[0], e[1], e[3], e[4]
    ex, ey = bx - ax, by - ay
    l2 = ex * ex + ey * ey
    u = max(0.0, min(1.0, ((px - ax) * ex + (py - ay) * ey) / l2)) if l2 > 0 else 0.0
    return math.hypot(px - (ax + u * ex), py - (ay + u * ey))


CLEAR = 250.0
ECELL = max(CLEAR, 64.0)
egrid = {}
for i, e in enumerate(borders):
    for ix in range(math.floor(min(e[0], e[3]) / ECELL), math.floor(max(e[0], e[3]) / ECELL) + 1):
        for iy in range(math.floor(min(e[1], e[4]) / ECELL), math.floor(max(e[1], e[4]) / ECELL) + 1):
            egrid.setdefault((ix, iy), []).append(i)


def clear_old(px, py):
    return all(seg_dist(px, py, e) >= CLEAR for e in borders)


def clear_new(px, py):
    kx, ky = math.floor(px / ECELL), math.floor(py / ECELL)
    for dx in (-1, 0, 1):
        for dy in (-1, 0, 1):
            for i in egrid.get((kx + dx, ky + dy), []):
                if seg_dist(px, py, borders[i]) < CLEAR:
                    return False
    return True


rng = random.Random(76)
xs = [c for t in tris for c in (t[0][0], t[1][0], t[2][0])]
ys = [c for t in tris for c in (t[0][1], t[1][1], t[2][1])]
zs = [c for t in tris for c in (t[0][2], t[1][2], t[2][2])]
N = 4000
pts = []
for _ in range(N):
    a, b, c = tris[rng.randrange(len(tris))]
    u, v = rng.random(), rng.random()
    if u + v > 1:
        u, v = 1 - u, 1 - v
    x = a[0] + u * (b[0] - a[0]) + v * (c[0] - a[0]) + rng.uniform(-30, 30)
    y = a[1] + u * (b[1] - a[1]) + v * (c[1] - a[1]) + rng.uniform(-30, 30)
    z = a[2] + u * (b[2] - a[2]) + v * (c[2] - a[2]) + rng.uniform(-60, 600)
    pts.append((x, y, z))
t0 = time.perf_counter()
old = [(floor_old(x, y, z, 40.0), floor_old(x, y, z - 520.0, 480.0), clear_old(x, y)) for x, y, z in pts]
t1 = time.perf_counter()
new = [(floor_new(x, y, z, 40.0), floor_new(x, y, z - 520.0, 480.0), clear_new(x, y)) for x, y, z in pts]
t2 = time.perf_counter()
diff = sum(1 for o, n in zip(old, new) if o != n)
found = sum(1 for o in old if o[0] is not None)
print(f"{len(tris)} triangles, {len(borders)} wall edges, {N} random points: {diff} different answers "
      f"({found} points had a floor). old {t1 - t0:.2f} s, grid {t2 - t1:.2f} s ({(t1 - t0) / (t2 - t1):.0f}x faster)")
