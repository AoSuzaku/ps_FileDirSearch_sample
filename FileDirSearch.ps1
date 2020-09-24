######################################################################
#
#　ファイル・ディレクトリ検索ツール
#
#　変更履歴
#　　・2020/09/25　新規作成
#
######################################################################

# ps1ファイルの格納先を取得
[string]$cDir = Split-Path $myInvocation.MyCommand.Path -Parent

# Mainクラス実行
$main = New-Object Main($cDir)
$main.FileSearch()

# Mainクラス
class Main{

	# 変数宣言
	[string]$cDir
	[string]$dir
	[object]$checkObj
	[object]$outObj
	
	# 配列宣言
    [object]$out
	
	# インスタンス生成
	Main([string]$cDir){
	
		$this.cDir = $cDir
		$this.dir = Read-Host "検索処理を実行するディレクトリパスを入力してください。"
		$this.checkObj = New-Object Check
		$this.outObj = New-Object Out
        $this.out = New-Object 'System.Collections.Generic.List[string]'
	
	}
	
	# ファイル検索
	[void]FileSearch(){
	
		try{
		
			# 入力・存在チェック
			if(!$this.checkObj.checkDir($this.dir)){
	
				Write-Host "検索処理を終了します。"
				return
	
			}
			
			# ファイル検索
			Get-ChildItem $this.dir -Recurse -File | %{
			
				# サブフォルダ配下のパス
				[string]$childDir = $_.Directory
				
				# ファイル名取得
				[string]$name = $_.name
				
				# ファイルサイズ
				[string]$size = $_.Length
				
				# ファイル更新日
				[string]$lastTime = $_.LastWriteTime.ToString("yyyy/MM/dd hh:mm")
				
				# 出力用配列に格納
        	    $this.out.Add("$($childDir),$($name),$($size),$($lastTime)")
			
			}
			
			# 出力処理
			$this.outObj.Output($this.cDir, $this.out)

            Write-Host "検索処理が正常終了しました。"
            Write-Host "処理を終了します。"
			
		}catch{
		
			Write-Host "処理中にエラーが発生しました。"
			Write-Host "ErrMsg：$($_.Exception.Message)"
		
		}
		
		# 終了処理
		$this.checkObj = $null
		$this.outObj = $null
		[GC]::Collect()
	
	}
	
}

# チェック用クラス
class Check{

	# インスタンス生成
	Check(){
	
	}

	# 入力・存在チェック
	[bool]checkDir([string]$dir){
	
		# 入力チェック
		if($dir -eq ""){

			Write-Host "検索処理を実行するディレクトリパスが入力されていません。"
			return $false

		# 存在チェック
		}elseif(!(Test-Path $dir)){

			Write-Host "検索処理を実行するディレクトリパスが存在しません。"
			return $false
			
		}

		return $true

	}

}

# 出力用クラス
class Out{

	# インスタンス生成
	Out(){
	
	}

	# 出力チェック
	[void]Output([string]$dir, [object]$out){
	
		try{
		
			if($out.Count -gt 0){
			
				echo "ディレクトリパス,ファイル名,ファイルサイズ（byte）,ファイル更新日" | Out-File -Append "$($dir)\result.csv"
				echo $out | Out-File -Append "$($dir)\result.csv"
			
			}
		
		}catch{
		
			throw
		
		}
	
	}
}

