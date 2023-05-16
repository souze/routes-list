module Evergreen.V12.Pages.Admin.ShowJson exposing (..)

import Evergreen.V12.BackupModel


type alias Model =
    { backup : Maybe String
    }


type Msg
    = BackupModelFromBackend Evergreen.V12.BackupModel.BackupModel
