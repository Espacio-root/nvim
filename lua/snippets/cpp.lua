local template = s(
    { trig = "temp", dsrc = "Competetive Programming Template" },
    fmta([[
#include <iostream>
#include <vector>

using namespace std;

#define int long long
#define inf 1e18

#define vi vector<int>
#define vvi vector<vector<int>>
#define vb vector<bool>
#define vvb vector<vector<bool>>
#define vc vector<char>
#define vvc vector<vector<char>>

using pii = pair<int,int>;
#define ff first
#define ss second

^type$ solve() {
    ^code$
}

int32_t main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    ^main$^cmd$
    return 0;
}
  ]], {
        main = c(1, { t({ "int t; cin>>t;", "    while(t--)", "        " }), t("") }),
        type = c(2, { t("int"), t("void"), t("bool"), t("string"), t("ll"), t("double"), t("long double"), t("pii") }),
        cmd = d(3, function(args, _)
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
        end, { 2 }),
        code = i(0)
    }, {
        delimiters = "^$"
    })
)

local sparse_table = s(
    { trig = "SPARSE_TABLE", dsrc = "Sparse Table Snippet" },
    fmta([[
vi log(n+1); log[1]=0;
for (int i=2; i<=n; i++) log[i]=log[i/2]+1;
int k = log[m];

auto stfn = [](int x, int y) {
    return ^main$;
};

vvi st(k+1, vi(m)), sm(k+1, vi(m));
st[0]=b;
for (int i=1; (1<<i)<=m; i++) {
    for (int j=0; j+(1<<i)<=m; j++) {
        st[i][j] = stfn(st[i-1][j], st[i-1][ j+(1<<(i-1)) ]);
    }
}

int i=log[r-l+1];
int mx=stfn(st[i][l], st[i][r-(1<<i)+1]);
  ]], {
        main = i(0),
    }, { delimiters = "^$" })
)

return {
    template,
    sparse_table,
}
