module Evergreen.V14.Pages.Admin.ShowJson exposing (..)

import Evergreen.V14.BackupModel


type alias Model =
    { backup : Maybe String
    }


type Msg
    = BackupModelFromBackend Evergreen.V14.BackupModel.BackupModel
