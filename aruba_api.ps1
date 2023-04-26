##############################################################################
#  証明書エラー回避                                                          #
##############################################################################

Add-Type @"
   using System.Net;
   using System.Security.Cryptography.X509Certificates;
   public class TrustAllCertsPolicy : ICertificatePolicy {
      public bool CheckValidationResult(
         ServicePoint srvPoint, X509Certificate certificate,
         WebRequest request, int certificateProblem) {
         return true;
      }
   }
"@

[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

try {

##############################################################################
#  変数定義                                                                  #
##############################################################################

    # apiログインRequest時のbody（arubauserとarubapassは環境変数に設定）
    $body = 'username=' + $env:arubauser + '&' + 'password=' + $env:arubapass
    
    #host定義（○○を適宜編集）
    $host = ○○

    # aruba WLCのログインURL
    $loginUrl = "https://$host/v1/api/login"

    # aruba WLCのログアウトURL
    $logoutUrl = "https://$host/v1/api/logout"

    # ShowAPDatabaseコマンド用URL（セッションIDを結合する）
    $showDatabase = 'https://$host/v1/configuration/showcommand?command=show+ap+database&UIDARUBA='

##############################################################################
#　ログイン処理                                                              #
##############################################################################

    # aruba WLCへ接続する
    $loginJson = invoke-RestMethod -Uri $loginUrl -Method POST -Body $body -SessionVariable session

    # cookieを変数cookieに格納する
    $cookie = $loginJson._global_result.UIDARUBA

    # showDatabase変数 + cookie変数をshowDatabaseUrl変数に格納する
    $showDatabaseUrl = $showDatabase + $cookie

##############################################################################
#　RestAPIにて各種showコマンド実施                                           #
##############################################################################

    ####ここに処理を書く（以下サンプル）####
    
    # show ap databaseコマンドを実行し、結果をapData変数へ格納する
    $apData = Invoke-RestMethod -Uri $showDatabaseUrl -Method GET -WebSession $session



##############################################################################
#　ログアウト処理                                                            #
##############################################################################

    # aruba WLCを切断する
    Invoke-RestMethod -Uri $logoutUrl -WebSession $session


} catch {
    
    #### 例外キャッチ時の処理を書く ####

}


