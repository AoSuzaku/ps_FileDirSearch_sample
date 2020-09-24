######################################################################
#
#�@�t�@�C���E�f�B���N�g�������c�[��
#
#�@�ύX����
#�@�@�E2020/09/25�@�V�K�쐬
#
######################################################################

# ps1�t�@�C���̊i�[����擾
[string]$cDir = Split-Path $myInvocation.MyCommand.Path -Parent

# Main�N���X���s
$main = New-Object Main($cDir)
$main.FileSearch()

# Main�N���X
class Main{

	# �ϐ��錾
	[string]$cDir
	[string]$dir
	[object]$checkObj
	[object]$outObj
	
	# �z��錾
    [object]$out
	
	# �C���X�^���X����
	Main([string]$cDir){
	
		$this.cDir = $cDir
		$this.dir = Read-Host "�������������s����f�B���N�g���p�X����͂��Ă��������B"
		$this.checkObj = New-Object Check
		$this.outObj = New-Object Out
        $this.out = New-Object 'System.Collections.Generic.List[string]'
	
	}
	
	# �t�@�C������
	[void]FileSearch(){
	
		try{
		
			# ���́E���݃`�F�b�N
			if(!$this.checkObj.checkDir($this.dir)){
	
				Write-Host "�����������I�����܂��B"
				return
	
			}
			
			# �t�@�C������
			Get-ChildItem $this.dir -Recurse -File | %{
			
				# �T�u�t�H���_�z���̃p�X
				[string]$childDir = $_.Directory
				
				# �t�@�C�����擾
				[string]$name = $_.name
				
				# �t�@�C���T�C�Y
				[string]$size = $_.Length
				
				# �t�@�C���X�V��
				[string]$lastTime = $_.LastWriteTime.ToString("yyyy/MM/dd hh:mm")
				
				# �o�͗p�z��Ɋi�[
        	    $this.out.Add("$($childDir),$($name),$($size),$($lastTime)")
			
			}
			
			# �o�͏���
			$this.outObj.Output($this.cDir, $this.out)

            Write-Host "��������������I�����܂����B"
            Write-Host "�������I�����܂��B"
			
		}catch{
		
			Write-Host "�������ɃG���[���������܂����B"
			Write-Host "ErrMsg�F$($_.Exception.Message)"
		
		}
		
		# �I������
		$this.checkObj = $null
		$this.outObj = $null
		[GC]::Collect()
	
	}
	
}

# �`�F�b�N�p�N���X
class Check{

	# �C���X�^���X����
	Check(){
	
	}

	# ���́E���݃`�F�b�N
	[bool]checkDir([string]$dir){
	
		# ���̓`�F�b�N
		if($dir -eq ""){

			Write-Host "�������������s����f�B���N�g���p�X�����͂���Ă��܂���B"
			return $false

		# ���݃`�F�b�N
		}elseif(!(Test-Path $dir)){

			Write-Host "�������������s����f�B���N�g���p�X�����݂��܂���B"
			return $false
			
		}

		return $true

	}

}

# �o�͗p�N���X
class Out{

	# �C���X�^���X����
	Out(){
	
	}

	# �o�̓`�F�b�N
	[void]Output([string]$dir, [object]$out){
	
		try{
		
			if($out.Count -gt 0){
			
				echo "�f�B���N�g���p�X,�t�@�C����,�t�@�C���T�C�Y�ibyte�j,�t�@�C���X�V��" | Out-File -Append "$($dir)\result.csv"
				echo $out | Out-File -Append "$($dir)\result.csv"
			
			}
		
		}catch{
		
			throw
		
		}
	
	}
}

