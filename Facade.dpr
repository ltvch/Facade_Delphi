program Facade;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

type
  (* complex parts - > Subsystem *)
  TCPU = class
    procedure Freeze;
    procedure Jump(position: Integer);
    procedure Execute;
  end;

  TMemory = class
    procedure Load(position: Integer; data: string);
  end;

  THardDrive = class
    function Read(lba, size: Integer): string;
  end;

  (* Facade *)
  TComputer = class
    fCPU: TCPU;
    fMemory: TMemory;
    fHardDrive: THardDrive;
    
  const
    BOOT_ADDRESS: Integer = 0;
    BOOT_SECTOR: Integer = 0;
    SECTOR_SIZE: Integer = 512;
  public
    procedure Start_Computer;
    constructor Create;
  end;

  { TCPU }

procedure TCPU.Execute;
begin
  WriteLn('CPU: execute');
end;

procedure TCPU.Freeze;
begin
  WriteLn('CPU: freese');
end;

procedure TCPU.Jump(position: Integer);
begin
  WriteLn('CPU: jump to ' + IntToStr(position));
end;

{ TMemory }

procedure TMemory.Load(position: Integer; data: string);
begin
  WriteLn('Memory: load "' + data + '" at ' + IntToStr(position));
end;

{ THardDrive }

function THardDrive.Read(lba, size: Integer): string;
begin
  WriteLn('HardDrive: read sector ' + IntToStr(lba) + ' (' + IntToStr(size) +
    ' bytes)');
  Result := 'hdd data';
end;

{ TComputer }

constructor TComputer.Create;
begin
  fCPU := TCPU.Create;
  fMemory := TMemory.Create;
  fHardDrive := THardDrive.Create;
end;

procedure TComputer.Start_Computer;
begin
  fCPU.Freeze;
  fMemory.Load(BOOT_ADDRESS, fHardDrive.Read(BOOT_SECTOR, SECTOR_SIZE));
  fCPU.Jump(BOOT_ADDRESS);
  fCPU.Execute;
end;

var
  facad: TComputer;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }

    facad := TComputer.Create;
    facad.Start_Computer;

    ReadLn;
    WriteLn(#13#10 + 'Press any key to continue...');
    facad.Free;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
