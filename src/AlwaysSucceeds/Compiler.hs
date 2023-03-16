{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

module AlwaysSucceeds.Compiler (writeAlwaysSucceedsScript) where

import Cardano.Api
import Codec.Serialise (serialise)
import qualified Data.ByteString.Lazy as LBS
import qualified Data.ByteString.Short as SBS
import qualified Plutus.V2.Ledger.Api
import Cardano.Api.Shelley (PlutusScript (..))
import PlutusTx.Prelude
import Prelude (FilePath, IO)

import AlwaysSucceeds.Validator as AlwaysSucceeds

-- If we do not import Ledger, then
-- how to replace Ledger.Validator?

writeValidator :: FilePath -> Plutus.V2.Ledger.Api.Validator -> IO (Either (FileError ()) ())
writeValidator file = writeFileTextEnvelope @(PlutusScript PlutusScriptV2) file Nothing . PlutusScriptSerialised . SBS.toShort . LBS.toStrict . serialise . Plutus.V2.Ledger.Api.unValidatorScript


writeAlwaysSucceedsScript :: IO (Either (FileError ()) ())
writeAlwaysSucceedsScript = writeValidator "output/always-succeeds.plutus" AlwaysSucceeds.validator

