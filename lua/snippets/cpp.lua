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
using vii = vector<pii>; using vvii = vector<vii>;
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
template <typename T>
struct SegTree {
    int n;
    vector<T> arr;

    static constexpr T def=0;
    T f(T &a, T &b) {
        return a+b;
    }

    SegTree(vector<T> &arr) {
        int m=1, n=arr.size();
        while (m<n) m*=2;
        this->n = m;
        this->arr.assign(2*this->n-1, def);
        build(0,this->n-1,0,arr);
    }

    void build(int l, int r, int x, vector<T> &arr) {
        if (r-l==0) {
            if (l<arr.size())
                this->arr[x]=arr[l];
            return;
        }
        int m=l+(r-l)/2;
        build(l,m,2*x+1,arr);
        build(m+1,r,2*x+2,arr);
        this->arr[x]=f(this->arr[2*x+1], this->arr[2*x+2]);
    }

    T query(int l, int r, int lx, int rx, int x) {
        if (lx>=l && rx<=r) return this->arr[x];
        if (lx>r || l>rx) return this->def;
        int m=lx+(rx-lx)/2;
        T s1=query(l,r,lx,m,2*x+1);
        T s2=query(l,r,m+1,rx,2*x+2);
        return f(s1,s2);
    }
    T query(int l, int r) {return query(l,r,0,this->n-1,0);}

    void set(int i, T v, int lx, int rx, int x) {
        if (rx-lx==0) {
            this->arr[x]=v; return;
        }
        int m=lx+(rx-lx)/2;
        if (i<=m) {
            set(i,v,lx,m,2*x+1);
        } else {
            set(i,v,m+1,rx,2*x+2);
        }
        this->arr[x]=f(this->arr[2*x+1], this->arr[2*x+2]);
    }
    void set(int i, T v) {set(i,v,0,this->n-1,0);}
};
  ]], {
    }, { delimiters = "^$" })
)

local lazysegtree = s(
    { trig = "LAZYSEGTREE", dsrc = "Lazy Segment Tree Snippet" },
    fmta([[
template <typename T>
struct LazySegTree {
    int n;
    vector<T> arr;
    vector<T> lazy;

    // ================= CONFIGURATION START =================
    // 1. Identity Element for Query (Sum: 0, Max: -1e18)
    static constexpr T q_def = 0;

    // 2. Identity Element for Lazy (Add: 0, Set: -1 (or generic flag))
    static constexpr T l_def = 0;

    // 3. Merge Logic for Query (Sum: a+b, Max: max(a,b))
    T f(T a, T b) {
        return a + b;
    }

    // 4. Apply Logic: How to apply update 'v' to node 'val' & lazy 'lz'
    //    'len' is the length of the current segment.
    void apply(T &val, T &lz, T v, int len) {
        // Example: Range Sum + Range Add
        val += v * len;
        lz += v;

        // Example: Range Max + Range Set
        // val = v;
        // lz = v;
    }
    // ================== CONFIGURATION END ==================

    LazySegTree(vector<T> &arr) {
        int m=1, n=arr.size();
        while (m<n) m*=2;
        this->n = m;
        this->arr.assign(2*this->n-1, q_def);
        this->lazy.assign(2*this->n-1, l_def);
        build(0,this->n-1,0,arr);
    }

    void build(int l, int r, int x, vector<T> &arr) {
        if (r-l==0) {
            if (l<arr.size())
                this->arr[x]=arr[l];
            return;
        }
        int m=l+(r-l)/2;
        build(l,m,2*x+1,arr);
        build(m+1,r,2*x+2,arr);
        this->arr[x]=f(this->arr[2*x+1], this->arr[2*x+2]);
    }

    void push(int lx, int rx, int x) {
        if (lazy[x] == l_def) return;
        int m = lx + (rx - lx) / 2;

        apply(arr[2*x+1], lazy[2*x+1], lazy[x], m - lx + 1);
        apply(arr[2*x+2], lazy[2*x+2], lazy[x], rx - m);

        lazy[x] = l_def;
    }

    void update(int l, int r, T v, int lx, int rx, int x) {
        if (lx>r || l>rx) return;
        if (lx>=l && rx<=r) {
            apply(arr[x], lazy[x], v, rx - lx + 1);
            return;
        }
        push(lx, rx, x);
        int m=lx+(rx-lx)/2;
        update(l,r,v,lx,m,2*x+1);
        update(l,r,v,m+1,rx,2*x+2);
        this->arr[x]=f(this->arr[2*x+1], this->arr[2*x+2]);
    }
    void update(int l, int r, T v) {update(l,r,v,0,this->n-1,0);}

    T query(int l, int r, int lx, int rx, int x) {
        if (lx>r || l>rx) return q_def;
        if (lx>=l && rx<=r) return this->arr[x];
        push(lx, rx, x);
        int m=lx+(rx-lx)/2;
        T s1=query(l,r,lx,m,2*x+1);
        T s2=query(l,r,m+1,rx,2*x+2);
        return f(s1,s2);
    }
    T query(int l, int r) {return query(l,r,0,this->n-1,0);}
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

local matrix_arr = s(
    { trig = "MATRIX_ARR", dsrc = "Matrix Exponentiation (Array)" },
    fmta([[
template <typename T, int N>
struct Matrix {
    T mat[N][N];

    // Constructor: Reset to 0
    Matrix() {
        memset(mat, 0, sizeof(mat));
    }

    // Accessor
    T* operator[](int i) {
        return mat[i];
    }
    const T* operator[](int i) const {
        return mat[i];
    }

    // Static Identity Matrix
    static Matrix identity() {
        Matrix res;
        for (int i = 0; i < N; i++) res.mat[i][i] = 1;
        return res;
    }

    // Addition
    Matrix operator+(const Matrix& other) const {
        Matrix res;
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                res.mat[i][j] = (mat[i][j] + other.mat[i][j]);
                if (res.mat[i][j] >= mod) res.mat[i][j] -= mod;
            }
        }
        return res;
    }

    // Multiplication (Optimized with Modulo)
    Matrix operator*(const Matrix& other) const {
        Matrix res;
        for (int i = 0; i < N; i++) {
            for (int k = 0; k < N; k++) {
                if (mat[i][k] == 0) continue; // Sparse optimization
                for (int j = 0; j < N; j++) {
                    res.mat[i][j] = (res.mat[i][j] + mat[i][k] * other.mat[k][j]) % mod;
                }
            }
        }
        return res;
    }

    // Binary Exponentiation
    Matrix power(long long p) const {
        Matrix res = Matrix::identity();
        Matrix base = *this;
        while (p > 0) {
            if (p & 1) res = res * base;
            base = base * base;
            p >>= 1;
        }
        return res;
    }

    // Print helper
    void print() {
        for(int i=0; i<N; i++) {
            for(int j=0; j<N; j++) cout << mat[i][j] << " ";
            cout << "\n";
        }
    }
};
  ]], {
    }, { delimiters = "@$" })
)

local matrix_vec = s(
    { trig = "MATRIX_VEC", dsrc = "Matrix Exponentiation (Vector)" },
    fmta([[
template <typename T>
class Matrix {
private:
    int rows;
    int cols;
    vector<vector<T>> mat;

public:
    // --- Constructors ---
    
    // 1. Default (0x0)
    Matrix() : rows(0), cols(0) {}

    // 2. Dimensions (initializes with default value)
    Matrix(int r, int c, T initialValue = T()) : rows(r), cols(c) {
        mat.assign(r, vector<T>(c, initialValue));
    }

    // 3. From 2D Vector
    Matrix(const vector<vector<T>>& v) : rows(v.size()), cols(v[0].size()), mat(v) {}

    // 4. From Initializer List (allows M = {{1,2}, {3,4}})
    Matrix(initializer_list<initializer_list<T>> lst) {
        rows = lst.size();
        cols = 0;
        if (rows > 0) cols = lst.begin()->size();
        
        mat.resize(rows);
        int i = 0;
        for (const auto& row_lst : lst) {
            assert(row_lst.size() == cols && "All rows must have same width");
            mat[i++] = vector<T>(row_lst);
        }
    }

    // --- Static Helpers ---
    static Matrix identity(int n) {
        Matrix res(n, n);
        for (int i = 0; i < n; i++) res.mat[i][i] = 1;
        return res;
    }

    // --- Accessors ---
    vector<T>& operator[](int row) { return mat[row]; }
    const vector<T>& operator[](int row) const { return mat[row]; }
    int getRows() const { return rows; }
    int getCols() const { return cols; }

    // --- Arithmetic Operations with Modulo ---

    // Addition
    Matrix operator+(const Matrix& other) const {
        assert(rows == other.rows && cols == other.cols);
        Matrix res(rows, cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                res.mat[i][j] = mat[i][j] + other.mat[i][j];
                if (res.mat[i][j] >= mod) res.mat[i][j] -= mod;
            }
        }
        return res;
    }

    // Subtraction
    Matrix operator-(const Matrix& other) const {
        assert(rows == other.rows && cols == other.cols);
        Matrix res(rows, cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                res.mat[i][j] = mat[i][j] - other.mat[i][j];
                if (res.mat[i][j] < 0) res.mat[i][j] += mod;
            }
        }
        return res;
    }

    // Multiplication
    Matrix operator*(const Matrix& other) const {
        assert(cols == other.rows);
        int k_dim = other.cols;
        Matrix res(rows, k_dim);
        
        for (int i = 0; i < rows; i++) {
            for (int k = 0; k < cols; k++) {
                if (mat[i][k] == 0) continue; 
                for (int j = 0; j < k_dim; j++) {
                    long long term = (1LL * mat[i][k] * other.mat[k][j]) % mod;
                    res.mat[i][j] = (res.mat[i][j] + term) % mod;
                }
            }
        }
        return res;
    }

    // --- Utilities ---
    
    // Matrix Exponentiation
    Matrix power(long long p) const {
        assert(rows == cols);
        Matrix res = Matrix::identity(rows);
        Matrix base = *this;
        while (p > 0) {
            if (p & 1) res = res * base;
            base = base * base;
            p >>= 1;
        }
        return res;
    }

    // Output
    friend ostream& operator<<(ostream& os, const Matrix& m) {
        for (int i = 0; i < m.rows; i++) {
            for (int j = 0; j < m.cols; j++) {
                os << m.mat[i][j] << (j == m.cols - 1 ? "" : " ");
            }
            os << "\n";
        }
        return os;
    }
};
  ]], {
    }, { delimiters = "@$" })
)

return {
    template,
    sparse_table,
    dsu,
    transpose,
    custom_hash,
    segtree,
    lazysegtree,
    lca,
    ordered_set,
    matrix_arr,
    matrix_vec
}
