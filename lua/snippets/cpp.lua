local template = s(
    { trig = "temp", dsrc = "Competetive Programming Template" },
    fmta([[
/**
 *    author:  espacio
 *    created: @time$
**/
#include <iostream>
#include <cstdint>
#include <vector>

using namespace std;

#define int long long
constexpr int inf = 1000000000000000000;

using pii = pair<int, int>;
using pll = pair<long long, long long>;

using vi = vector<int>; using vvi = vector<vi>;
using vb = vector<bool>; using vvb = vector<vb>;
using vc = vector<char>; using vvc = vector<vc>;
using vs = vector<string>; using vvs = vector<vs>;

#define ff first
#define ss second

/** small observations:
**/

@type$ solve() {
    @code$
}

int32_t main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    @main$@cmd$
    return 0;
}
  ]], {
        time = d(1, function()
            return sn(nil, t(os.date("%d.%m.%Y %H:%M:%S")))
        end),
        main = c(2, { t({ "int t; cin>>t;", "    while(t--)", "        " }), t("") }),
        type = c(3, { t("int"), t("void"), t("bool"), t("ll"), t("string"), t("double"), t("long double"), t("pii") }),
        cmd = d(4, function(args, _)
            local snipText = args[1][1];
            if (snipText == "int" or snipText == "ll" or snipText == "double" or snipText == "long double" or snipText == "string") then
                return sn(nil, { t("cout << solve() << endl;") })
            elseif (snipText == "void") then
                return sn(nil, { t("solve();") })
            elseif (snipText == "bool") then
                return sn(nil, { t("cout << (solve() ? \"YES\" : \"NO\") << endl;") })
            elseif (snipText == "pii") then
                return sn(nil, { t("{auto [x,y] = solve(); cout << x << \" \" << y << endl;}") })
            end
        end, { 3 }),
        code = i(0)
    }, {
        delimiters = "@$"
    })
)

local sparse_table = s(
    { trig = "SPARSE_TABLE", dsrc = "Sparse Table Snippet" },
    fmta([[
struct SparseTable {
    int n, K;
    vi log;
    vvi st;

    SparseTable(const vi &a) {
        n = (int)a.size();
        log.resize(n + 1);
        log[1] = 0;
        for (int i = 2; i <= n; i++)
            log[i] = log[i/2] + 1;

        K = log[n];
        st.assign(K+1, vi(n));

        for (int i = 0; i < n; i++) st[0][i] = a[i];

        for (int k = 1; k <= K; k++) {
            for (int i = 0; i + (1<<k) <= n; i++) {
                st[k][i] = max(st[k-1][i], st[k-1][i + (1<<(k-1))]);
            }
        }
    }

    int query(int l, int r) { // 0-indexed, inclusive
        int j = log[r-l+1];
        return max(st[j][l], st[j][r - (1<<j) + 1]);
    }
};
  ]], {
    }, { delimiters = "^$" })
)

local dsu = s(
    { trig = "DSU", dsrc = "Disjoint Set Union Snippet" },
    fmta([[
struct DSU {
    vi parent, size;

    DSU (int n) {
        parent.resize(n+1); size.assign(n+1,1);
        for (int i=1; i<=n; i++) parent[i]=i;
    }

    int get(int u) {
        if (parent[u]==u) return u;
        return parent[u]=get(parent[u]);
    }

    void unite(int u, int v) {
        int pu=get(u), pv=get(v);
        if (pu==pv) return;

        if (size[pu]<size[pv]) swap(pu,pv);
        parent[pv]=pu;
        size[pu]+=size[pv];
    }
};
  ]], {
    }, { delimiters = "^$" })
)

local transpose = s(
    { trig = "TRANSPOSE", ssrc = "Transpose Matrix" },
        fmta([[
template <typename T>
vector<vector<T>> transpose(const vector<vector<T>>& matrix) {
    if (matrix.empty()) return {};

    size_t rows = matrix.size();
    size_t cols = matrix[0].size();

    vector<vector<T>> result(cols, vector<T>(rows));

    for (size_t i = 0; i < rows; ++i) {
        for (size_t j = 0; j < cols; ++j) {
            result[j][i] = matrix[i][j];
        }
    }

    return result;
}
        ]], {}, {delimiters = "^$"})
)

local custom_hash = s(
    { trig="HASH", ssrc = "Custom Hash Fn"},
        fmta([[
#include <chrono>

struct custom_hash {
    static uint64_t splitmix64(uint64_t x) {
        // http://xorshift.di.unimi.it/splitmix64.c
        x += 0x9e3779b97f4a7c15;
        x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
        x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
        return x ^ (x >> 31);
    }

    size_t operator()(uint64_t x) const {
        static const uint64_t FIXED_RANDOM = chrono::steady_clock::now().time_since_epoch().count();
        return splitmix64(x + FIXED_RANDOM);
    }
};
        ]], {}, {delimiters="!$"})
)


local segtree = s(
    { trig = "SEGTREE", dsrc = "Segment Tree Snippet" },
    fmta([[
struct segtree {
    int s;
    vector<int> sm;

    void init(int n) {
        s=1;
        while (n>s) s*=2;
        sm.assign(2*s, 0ll);
    }

    int f(int x, int y) {
        return x+y;
    }

    void build(vector<int> &a, int x, int lx, int rx) {
        if (rx-lx==1) {
            if (lx<a.size()) sm[x]=a[lx];
            return;
        }
        int m=(lx+rx)/2;
        build(a, 2*x+1, lx, m);
        build(a, 2*x+2, m, rx);
        sm[x] = f(sm[2*x+1],sm[2*x+2]);
    }
    void build(vector<int> &a) {build(a,0,0,s);}

    void set(int i, int v, int x, int lx, int rx) {
        if (rx-lx==1) {
            sm[x]=v;
            return;
        }
        int m=(lx+rx)/2;
        if (i<m) {
            set(i, v, 2*x+1, lx, m);
        } else {
            set(i, v, 2*x+2, m, rx);
        }
        sm[x] = f(sm[2*x+1],sm[2*x+2]);
    }
    void set(int i, int v) {set(i,v,0,0,s);}

    int get(int l, int r, int x, int lx, int rx) {
        if (lx>=r || l>=rx) return inf;
        if (lx>=l && rx<=r) return sm[x];
        int m=(lx+rx)/2;
        int s1=get(l, r, 2*x+1, lx, m);
        int s2=get(l, r, 2*x+2, m, rx);
        return f(s1,s2);
    }
    int get(int l, int r) {return get(l,r+1,0,0,s);}
};
  ]], {
    }, { delimiters = "^$" })
)

local lca = s(
    { trig = "LCA", dsrc = "Lowest Common Ancestor Snippet" },
    fmta([=[
int timer=0, l=ceil(log2(n));
vi tin(n+1), tout(n+1);
vvi up(n+1, vi(l+1));
auto dfsLca=[&](auto& self, int u, int p)->void {
    tin[u]=timer++;
    up[u][0]=p;
    for (int i=1; i<=l; i++) {
        up[u][i]=up[up[u][i-1]][i-1];
    }
    for (auto v: adj[u]) {
        if (v==p) continue;
        self(self,v,u);
    }
    tout[u]=timer++;
};
dfsLca(dfsLca,1,1);

auto is_ancestor=[&](int u, int v)->bool {
    return tin[u]<=tin[v] && tout[u]>=tout[v];
};
auto lca=[&](int u, int v)->int {
    if (is_ancestor(u, v)) return u;
    if (is_ancestor(v, u)) return v;
    for (int i=l; i>=0; i--) {
        if (!is_ancestor(up[u][i], v)) {
            u=up[u][i];
        }
    }
    return up[u][0];
};
  ]=], {
    }, { delimiters = "^$" })
)

local ordered_set = s(
    { trig = "ORDERED_SET", dsrc = "Ordered Set" },
    fmta([[
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace __gnu_pbds;
#define ordered_set tree<int, null_type,less<int>, rb_tree_tag,tree_order_statistics_node_update>
  ]], {
    }, { delimiters = "^$" })
)


return {
    template,
    sparse_table,
    dsu,
    transpose,
    custom_hash,
    segtree,
    lca,
    ordered_set
}
