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
#include <random>
#include <chrono>

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

mt19937_64 rng(chrono::steady_clock::now().time_since_epoch().count());

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

    static constexpr T def=-1;
    T f(T &a, T &b) {
        return max(a,b);
    }

    SegTree(int n) {
        int m=1;
        while (m<n) m*=2;
        this->n = m;
        this->arr.assign(2*this->n-1, def);
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
    void build(vector<T> &arr) {build(0,this->n-1,0,arr);}

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

local stress_gen = s(
    { trig = "GEN", dsrc = "Test Case Generator" },
    fmta([[
namespace Gen {
    long long rand_int(long long l, long long r) {
        return uniform_int_distribution<long long>(l,r)(rng);
    }

    vector<long long> gen_array(int min_n, int max_n, long long min_val, long long max_val) {
        int n=(min_n==max_n?min_n:rand_int(min_n,max_n));
        vector<long long> a(n);
        for (int i=0; i<n; i++) {
            a[i]=rand_int(min_val,max_val);
        }
        return a;
    }

    string gen_string(int min_n, int max_n, const string& alphabet = "abcdefghijklmnopqrstuvwxyz") {
        int n=(min_n==max_n?min_n:rand_int(min_n,max_n));
        string s="";
        for (int i=0; i<n; i++) s+=alphabet[rand_int(0,alphabet.length()-1)];
        return s;
    }
}

namespace GenGraph {
    string random_tree(int n) {
        stringstream ss;
        ss<<n<<'\n';
        for (int u=2; u<=n; u++) {
            int v=Gen::rand_int(1, u-1);
            if (Gen::rand_int(0, 1)) swap(u, v);
            ss<<u<<' '<<v<<'\n';
        }
        return ss.str();
    }
}

namespace Gen {
    void generate() {
        int n=Gen::rand_int(1,1000);
        cout<<n<<'\n';
    }
}
  ]], {
    }, { delimiters = "@$" })
)

local stress_test = s(
    { trig = "STRESS", dsrc = "Stress Tester - Brute vs Solve" },
    fmta([[
void stress() {
    int test_cases=0;
    streambuf* original_cin = cin.rdbuf();
    streambuf* original_cout = cout.rdbuf();

    while (true) {
        test_cases++;

        stringstream ss_test;
        cout.rdbuf(ss_test.rdbuf());
        Gen::generate();
        string tc_string=ss_test.str();
        cout.rdbuf(original_cout);

        // void return type
        // stringstream ss_in_slow(tc_string);
        // ostringstream ss_out_slow;
        // cin.rdbuf(ss_in_slow.rdbuf());
        // cout.rdbuf(ss_out_slow.rdbuf());
        // brute();
        // auto slow_ans=ss_out_slow.str();
        //
        // stringstream ss_in_fast(tc_string);
        // ostringstream ss_out_fast;
        // cin.rdbuf(ss_in_fast.rdbuf());
        // cout.rdbuf(ss_out_fast.rdbuf());
        // solve();
        // auto fast_ans=ss_out_fast.str();

        // non-void return type
        stringstream ss_slow(tc_string);
        cin.rdbuf(ss_slow.rdbuf());
        auto slow_ans=brute();

        stringstream ss_fast(tc_string);
        cin.rdbuf(ss_fast.rdbuf());
        auto fast_ans=solve();

        if (slow_ans != fast_ans) {
            cin.rdbuf(original_cin);
            cout << "Wrong Answer found on Test " << test_cases << "!\n";
            cout << "--- Input ---\n" << tc_string;
            cout << "--- Slow Output ---\n" << slow_ans << "\n";
            cout << "--- Fast Output ---\n" << fast_ans << "\n";
            break;
        }

        if (test_cases % 1000 == 0) {
            cin.rdbuf(original_cin);
            cout << test_cases << " tests passed...\n";
        }
    }
    cin.rdbuf(original_cin);
}
  ]], {
    }, { delimiters = "@$" })
)

local stress_checker = s(
    { trig = "CHECK", dsrc = "Checker for Stress Testing" },
    fmta([[
bool checker(string tc_string, string ans, string &feedback) {
    stringstream ss_in(tc_string), ss_ans(ans);

    int res; ss_ans<<ans;

    int n; ss_in>>n;
    int sm=0;
    for (int i=0; i<n; i++) {
        int v; ss_in>>v;
        sm+=v;
    }

    return sm==res;
}

void stress() {
    int test_cases=0;
    streambuf* original_cin = cin.rdbuf();
    streambuf* original_cout = cout.rdbuf();

    while (true) {
        test_cases++;

        stringstream ss_test;
        cout.rdbuf(ss_test.rdbuf());
        Gen::generate();
        string tc_string=ss_test.str();
        cout.rdbuf(original_cout);

        // void return type
        stringstream ss_in_fast(tc_string);
        ostringstream ss_out_fast;
        cin.rdbuf(ss_in_fast.rdbuf());
        cout.rdbuf(ss_out_fast.rdbuf());
        solve();
        auto ans=ss_out_fast.str();

        // non-void return type
        // stringstream ss_in(tc_string);
        // cin.rdbuf(ss_in.rdbuf());
        //
        // stringstream ss_out;
        // ss_out<<solve();
        // string ans=ss_out.str();

        stringstream feedback;

        if (!checker(tc_string, ans, feedback)) {
            cin.rdbuf(original_cin);
            cout.rdbuf(original_cout);
            cout << "Wrong Answer found on Test " << test_cases << "!\n";
            string feedback_str=feedback.str();
            if (!feedback_str.empty()) {
                cout << "--- Feedback -- \n" << feedback_str << "\n";
            }
            cout << "--- Input ---\n" << tc_string;
            cout << "--- Output ---\n" << ans << "\n";
            break;
        }

        if (test_cases % 1000 == 0) {
            cin.rdbuf(original_cin);
            cout.rdbuf(original_cout);
            cout << test_cases << " tests passed...\n";
        }
    }
    cin.rdbuf(original_cin);
}
  ]], {
    }, { delimiters = "@$" })
)

local nCr = s(
    { trig = "NCR", dsrc = "Combinatorics (nCr)" },
    fmta([[
const int N = 1e6+5, mod = 1e9+7;
vi fact(2*N+1);

void pre() {
    fact[0]=fact[1]=1;
    for (int i=2; i<=2*N; i++) fact[i]=(fact[i-1]*i)%mod;
}

int modPow(int a, int b) {
    int ans=1;
    a%=mod;
    while (b) {
        if (b%2) ans=(ans*a)%mod;
        a=(a*a)%mod; b/=2;
    }
    return ans;
}

int modInv(int a) {
    if (a==0) return 0;
    return modPow(a,mod-2);
}

int nCr(int n, int r) {
    if (r<0 || r>n) return 0;
    int num=fact[n];
    int den=(fact[r]*fact[n-r])%mod;
    return (num*modInv(den))%mod;
}
  ]], {
    }, { delimiters = "@$" })
)

local cht = s(
    { trig = "CHT", dsrc = "Convex Hull Trick (CHT)" },
    fmta([[
struct Line {
    long long m, c;

    long long eval(long long x) const {
        return m * x + c;
    }

    long double intersectX(const Line& other) const {
        return (long double)(other.c - c) / (m - other.m);
    }
};

struct CHT {
    vector<Line> hull;

    bool is_redundant(const Line& l1, const Line& l2, const Line& l3) {
        return l1.intersectX(l3) <= l1.intersectX(l2);
    }

    // slopes must be added in strictly increasing order
    void add(long long m, long long c) {
        Line L = {m, c};
        while (hull.size() >= 2 && is_redundant(hull[hull.size()-2], hull.back(), L)) {
            hull.pop_back();
        }
        hull.push_back(L);
    }

    long long query(long long x) {
        if (hull.empty()) return -4e18;

        int l = 0, r = hull.size() - 2;
        int best_line_idx = hull.size() - 1;

        while (l <= r) {
            int mid = l + (r - l) / 2;

            if (hull[mid].intersectX(hull[mid+1]) <= x) {
                l = mid + 1;
            } else {
                best_line_idx = mid;
                r = mid - 1;
            }
        }
        return hull[best_line_idx].eval(x);
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
    matrix_vec,
    stress_gen,
    stress_test,
    stress_checker,
    nCr,
    cht
}
