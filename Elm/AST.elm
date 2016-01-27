module AST where

import Dict exposing (Dict)


type alias Module =
  { name : List String
  , exports : List Exposable
  , imports : Import
  , declarations : List Declaration
  }


type alias Import =
  { moduleName : List String
  , asName : String
  , exposed : List Exposable
  }


type Exposable
  = BasicNameEx String
  | TypeAndEx String (List String)


type alias TypeEnv =
  Dict String TypeExpr


type Expr
  = App Expr Expr
  | ListLiteral (List Expr)
  | IntLiteral Int
  | StringLiteral String
  | CharLiteral Char
  | Tuple (List Expr)
  | IfExpr Expr Expr Expr
  | PatternMatch Expr (List (Pattern, Expr))
  | LetBinding (List (String, Expr)) Expr
  | Variable (List String)
  | RecordConstructor (List (String, Expr))
  | RecordUpdate
      { variable : String
      , updates : List (String, Expr)
      }


type Pattern
  = StringLiteralPat String
  | IntLiteralPat Int
  | CharLiteralPat Char
  | ConstructorPat (List String) (List Pattern)
  | ListPat (List Pattern)
  | RecordPat (List String)


type Declaration
  = FunctionDecl
      { name : String
      , typeDecl : TypeExpr
      , params : String
      , body : Expr
      }
  | TypeDecl TypeDecl


type TypeDecl
  = UnionTypeDecl String (List String) (List ConstructorDecl)
  | TypeAliasDecl String TypeExpr


type alias ConstructorDecl =
  { name : String
  , args : List TypeExpr
  }


type TypeExpr
  = TypeApp TypeExpr TypeExpr
  | RecordType (List String TypeExpr)
  | TypeVar String
  | NamedType (List String)
