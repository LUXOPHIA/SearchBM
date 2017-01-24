unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  LUX;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    GroupBox1: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { private 宣言 }
    _Array    :TArray<Word>;
    _ArrayN   :Integer;
    _ArrayW   :Integer;
    _ArrayH   :Integer;
    _Pattern  :TArray<Word>;
    _PatternN :Integer;
    ///// メソッド
    procedure MakeArray( const ArrayW_,ArrayH_:Integer );
    procedure ShowArray;
    procedure MakePattern( const PatternN_:Integer );
    procedure ShowPattern;
    procedure HidePattern( const HideN_:Integer );
    procedure ShowMatch;
  public
    { public 宣言 }
    _SearchBM :TSearchBM<Word>;
    _MatchI   :Integer;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.MakeArray( const ArrayW_,ArrayH_:Integer );
var
   I :Integer;
begin
     _ArrayW := ArrayW_;
     _ArrayH := ArrayH_;

     _ArrayN := _ArrayH * _ArrayW;

     SetLength( _Array, _ArrayN );

     for I := 0 to _ArrayN-1 do _Array[ I ] := Random( Word.MaxValue+1 );
end;

procedure TForm1.ShowArray;
var
   X, Y, I :Integer;
   S :String;
begin
     with Memo1.Lines do
     begin
          Clear;

          for Y := 0 to _ArrayH-1 do
          begin
               I := _ArrayW * Y;

               S := _Array[ I ].ToHexString( 4{文字} );

               for X := 1 to _ArrayW-1 do
               begin
                    S := S + ' ' + _Array[ I+X ].ToHexString( 4{文字} );
               end;

               Add( S );
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.MakePattern( const PatternN_:Integer );
var
   I :Integer;
begin
     _PatternN := PatternN_;

     SetLength( _Pattern, _PatternN );

     for I := 0 to _PatternN-1 do _Pattern[ I ] := Random( Word.MaxValue+1 );
end;

procedure TForm1.ShowPattern;
var
   S :String;
   I :Integer;
begin
     S := _Pattern[ 0 ].ToHexString( 4{文字} );

     for I := 1 to _PatternN-1 do
     begin
          S := S + ' ' + _Pattern[ I ].ToHexString( 4{文字} );
     end;

     Edit1.Text := S;
end;

procedure TForm1.HidePattern( const HideN_:Integer );
var
   N, I0, I :Integer;
begin
     for N := 1 to HideN_ do
     begin
          I0 := Random( _ArrayN - _PatternN );

          for I := 0 to _PatternN-1 do _Array[ I0 + I ] := _Pattern[ I ];
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.ShowMatch;
//････････････････････････
     function CellI( const I_:Integer ) :Integer;
     var
        X, Y :Integer;
     begin
          X := I_ mod _ArrayW;
          Y := I_ div _ArrayW;

          Result := ( 4{文字} * _ArrayW + _ArrayW-1 + 2{改行} ) * Y + 5{文字+空白} * X;
     end;
//････････････････････････
begin
     with Memo1 do
     begin
          if _MatchI < 0 then
          begin
               SelStart  := 0;
               SelLength := 0;
          end
          else
          begin
               SelStart  := CellI( _MatchI );
               SelLength := CellI( _MatchI + _PatternN-1 ) + 4{文字} - CellI( _MatchI );
          end;

          SetFocus;

          Caret.Hide;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _SearchBM := TSearchbm<Word>.Create;

     Button1Click( Sender );
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _SearchBM.Free;
end;

//------------------------------------------------------------------------------

procedure TForm1.Button1Click(Sender: TObject);
begin
     MakeArray( 16{列}, 32{行} );

     MakePattern( 1 + Random( 8 ) );

     ShowPattern;

     _SearchBM.Pattern := _Pattern;

     HidePattern( 8 );  // Pattern を Array の様々な場所へ上書きする（隠す）

     ShowArray;

     _MatchI := _SearchBM.Match( _Array );

     ShowMatch;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     _MatchI := _SearchBM.Match( _Array, _MatchI + 1 );

     ShowMatch;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     _MatchI := _SearchBM.Match( _MatchI + 1, _ArrayN,
          function( const I_:Integer ) :Word
          begin
               Result := _Array[ I_ ];
          end );

     ShowMatch;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     _MatchI := _SearchBM.Match( _MatchI + 1, _ArrayN,
          procedure( const HeadI_:Integer; const Buffer_:TArray<Word> )
          begin
               Move( _Array[ HeadI_ ], Buffer_[0], SizeOf( Word ) * _PatternN );
          end );

     ShowMatch;
end;

end. //######################################################################### ■
