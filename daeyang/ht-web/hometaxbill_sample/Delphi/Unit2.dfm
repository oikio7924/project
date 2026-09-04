object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 546
  ClientWidth = 603
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Button1: TButton
    Left = 518
    Top = 289
    Width = 75
    Height = 25
    Caption = #51204#49569
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo2: TMemo
    Left = 8
    Top = 320
    Width = 585
    Height = 218
    Lines.Strings = (
      'Memo2')
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 327
    Top = 290
    Width = 185
    Height = 24
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object StaticText1: TStaticText
    Left = 160
    Top = 289
    Width = 136
    Height = 25
    Caption = #54856#53469#49828#48716' '#44208#44284#51312#54924
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object Button2: TButton
    Left = 518
    Top = 8
    Width = 75
    Height = 25
    Caption = #51204#49569
    TabOrder = 4
    OnClick = Button2Click
  end
  object Memo3: TMemo
    Left = 8
    Top = 39
    Width = 585
    Height = 217
    Lines.Strings = (
      'Memo3')
    TabOrder = 5
  end
  object Memo4: TMemo
    Left = 327
    Top = 8
    Width = 185
    Height = 25
    Lines.Strings = (
      'Memo4')
    TabOrder = 6
  end
  object StaticText2: TStaticText
    Left = 192
    Top = 8
    Width = 104
    Height = 25
    Caption = #54856#53469#49828#48716' '#51204#49569
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
  end
  object Request: TRESTRequest
    Method = rmPOST
    Params = <>
    Response = RESTResponse1
    Left = 88
    Top = 270
  end
  object IdHTTP: TIdHTTP
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 24
    Top = 270
  end
  object RESTResponse1: TRESTResponse
    Left = 136
    Top = 272
  end
end
