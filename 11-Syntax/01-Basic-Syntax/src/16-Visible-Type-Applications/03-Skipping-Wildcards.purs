module Syntax.Basic.VisibleTypeApplications.SkippingWildcards where

-- Because order matters and because a single function may have 
-- multiple VTA-supported type variables, we may sometimes run
-- into another problem.

multipleTypes
  :: forall @skip @specify @other1 @other2
   . skip
  -> specify
  -> other1
  -> other2
  -> String
multipleTypes _skip _specify _other1 _other2 = "returned value"

-- Let's say we only want to use VTAs to specify the type for the 
-- second VTA-supported type variable (i.e `specify` above) 
-- without specifying the first one (e.g. `skip`).
-- We can only type-apply the second one after we have 
-- type-applied the first. So, how can we achieve our goal?

-- Fortunately, PureScript uses the wildcard VTA syntax (i.e. `@_`)
-- to skip type variables, so that one can type-apply other ones.

onlySpecifyTypeApplied
  :: forall skip other1 other2
   . skip
  -> String
  -> other1
  -> other2
  -> String
onlySpecifyTypeApplied = multipleTypes @_ @String

-- Again, if we want the VTA-support to be added to the derived function
-- we need to opt-in to that syntax:

onlySpecifyTypeApplied'
  :: forall @skip @other1 @other2
   . skip
  -> String
  -> other1
  -> other2
  -> String
onlySpecifyTypeApplied' = multipleTypes @_ @String
