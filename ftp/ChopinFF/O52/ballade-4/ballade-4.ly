%%--------------------------------------------------------------------
% LilyPond typesetting of Chopin Ballade No. 4, Op. 52
%%--------------------------------------------------------------------

%%%%%%% Notes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

%%%%%%% Editorial Notes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% * The sustain pedals starting from bar 13 are completely repetitive
%   till bar 36, so the shorthand by Paderewski is used, reducing
%   noise and compacting staves at the same time.
%
% * Trill at bar 50: Every edition on IMSLP contains trill spanner and
%   grace notes except Joseffy's; the list even includes its (supposed)
%   predecessor, Edition Peters. Though the ending notes
%   should have been implied even without grace notes, it would be safer
%   to spell them out explicitly.
%

%%%%%%% Known Problems %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

\version "2.18.0"

\paper {
  top-margin = 8\mm
  top-markup-spacing.basic-distance = #6         %-dist. from bottom of top margin to the first markup/title
  markup-system-spacing.basic-distance = #5      %-dist. from header/title to first system
  top-system-spacing.basic-distance = #12        %-dist. from top margin to system in pages with no titles
  last-bottom-spacing.basic-distance = #12       %-pads music from copyright block

  % ragged-right = ##f
  ragged-last = ##t
  ragged-bottom = ##t
  ragged-last-bottom = ##t

  % debug-slur-scoring = ##t
}

\header {
  title      = "Quatrième Ballade"
  opus       = "Op. 52"
  composer   = "F. Chopin"
  date       = "1842"
  source     = "Schirmer, 1916 [Rafael Joseffy]"
  style      = "Romantic"
  license    = "Public Domain"
  maintainer = "Abel Cheung"
  maintainerEmail = "abelcheung at gmail.com"
  moreInfo   = "Originally typesetted by Bruce J Keeler &lt;bruce@gridpoint.com&gt;, 2004"
  lastupdated = "2014-09-02"

  mutopiatitle      = "Chopin Ballade number 4"
  mutopiacomposer   = "ChopinFF"
  mutopiainstrument = "Piano"

 footer = "Mutopia-2004/03/20-422"
 copyright =  \markup { \override #'(baseline-skip . 0 ) \right-column { \sans \bold \with-url #"http://www.MutopiaProject.org" { \abs-fontsize #9  "Mutopia " \concat { \abs-fontsize #12 \with-color #white \char ##x01C0 \abs-fontsize #9 "Project " } } } \override #'(baseline-skip . 0 ) \center-column { \abs-fontsize #12 \with-color #grey \bold { \char ##x01C0 \char ##x01C0 } } \override #'(baseline-skip . 0 ) \column { \abs-fontsize #8 \sans \concat { " Typeset using " \with-url #"http://www.lilypond.org" "LilyPond " \char ##x00A9 " " 2014 " by " \maintainer " " \char ##x2014 " " \footer } \concat { \concat { \abs-fontsize #8 \sans{ " " \with-url #"http://creativecommons.org/licenses/by-sa/4.0/" "Creative Commons Attribution ShareAlike 4.0 International License " \char ##x2014 " free to distribute, modify, and perform" } } \abs-fontsize #13 \with-color #white \char ##x01C0 } } }
 tagline = ##f
}

%-------- Util and shorthands

lh = { \change Staff="LH" \voiceOne }
rh = { \change Staff="RH" \voiceTwo }
ct = \clef treble
cb = \clef bass
piuf = \markup { \italic "più" \dynamic "f" }
semprepiuf = \markup { \italic "sempre più" \dynamic "f" }
rf = #(make-dynamic-script "rf")
oD = \once \omit DynamicText
oH = \once \omit Hairpin
pd = \sustainOn
pu = \sustainOff

% Relax requirement so kneed beam is always possible
kneed-beam = { \once \override Beam.auto-knee-gap = #0 }

crescWithText =
#(define-music-function (parser location text) (string?)
   #{
     \once \set crescendoSpanner = #'text
     \once \override DynamicTextSpanner.text = $text
   #})
dimWithText =
#(define-music-function (parser location text) (string?)
   #{
     \once \set decrescendoSpanner = #'text
     \once \override DynamicTextSpanner.text = $text
   #})

slurChoice =
#(define-music-function (parser location start end)
   (integer? integer?)
   #{ \once \override Slur.positions = #(cons start end) #})

%-------- Custom articulation

% Default tenuto hides inside slur, pushing slurs outwards and prevent
% staves to be compacted. And padding is too small, so it can stick
% very close to beams.
#(define my-script-alist (list-copy default-script-alist))
#(set! my-script-alist
       (acons "tenutoalt"
         (acons 'avoid-slur 'outside
           (acons 'quantize-position #f
             (acons 'padding 0.4
              (assoc-ref default-script-alist "tenuto"))))
         my-script-alist))

tenutoAlt = #(make-articulation "tenutoalt")

#(assoc-set! (assoc-ref my-script-alist "tenuto") 'padding 0.4)

%-------- Right Hand parts
RH = \relative c'' {
  <<
    \relative c'' {
      \temporary \override DynamicLineSpanner.direction = #UP
      \oD <g g'>8(\p q q q q q |
      q\< q q\! q\> <f f'> <e e'>\! |
      q <d d'> <c c'> e'4.)-> |
      \once \override Slur.height-limit = 3.0
      <e, g'>8(\arpeggio <g g'> q q <f f'> <e e'> |
      <<
        { <e e'>8 <d d'> <c c'> }
        {
          <>-\tweak height 0.4
            -\tweak rotation #'(-4 -1.5 0)
            -\tweak outside-staff-priority ##f \>
          \skip 8. <>\!
        }
      >> e'4.)-> |
      <<
        { <e, e'>8( <d d'> <c c'> }
        {
          <>-\tweak height 0.4
            -\tweak rotation #'(-4 -1 0)
            -\tweak X-offset 4
            -\tweak outside-staff-priority ##f \>
          \skip 8 <>\!
        }
      >>
      %% Tie after line break is too short because of accidental blocking
      \shape #'(() ((0 . 0)(0.6 . 0.25)(1.2 . 0.25)(1.8 . 0))) Tie
      e'4.~ |
      e4.~ e4)\fermata
      \revert DynamicLineSpanner.direction
    } \\
    \relative c'' {
      \skip 4. g16 c g c g c |
      g <bes c> g q g q g <a c> f q e q |
      e <g b> d q c g' e <g c> e <f c'> e <g c> |
      e c' g <bes c> g q g <a c> f q e q |
      e <g b> d q c g' e <g c> e <f c'> e <g c> |
      e <g b> d q c g'
      \repeat unfold 2 { e <g c> e <f c'> }
      e <g c> e <f c'~> <e c'>4
    }
  >>
  c=''8(->~ |

  \barNumberCheck 8
  c des b~ b c f |
  e bes des4 c8 f |
  e bes des) r c16( des c des |
  es8) es( es es des16 c bes c |
  aes8) r r r4 r8 |

  \barNumberCheck 13
  r es'( aes g des fes~ |
  fes es aes g des fes) |
  r es16( f es f ges8) ges( ges |
  ges f16 c es des bes8) r r |

  \barNumberCheck 17
  r des16( es des es f8) f( f |
  f es16 bes des c a8)\noBeam c( f |
  e bes des4 c8 f |
  e bes des) r c16( des c des |
  es8) es( es es f16 c es des |
  bes4. g4) r8 |

  \barNumberCheck 23
  r c( f e bes des~ |
  des c f~ f16 e bes c es des) |
  r8 c16( des c des es8) es( es |
  es des16 c bes c aes8) r r |

  \barNumberCheck 27
  r4 r8 r es'( aes |
  g des fes4 es8 aes~ |
  aes16 g des es ges fes) r8 es16( f es f |
  ges8) ges( ges ges f16 c es des |
  bes8) r r r des16( es des es |
  f8) f( f f es16 bes des c |

  \barNumberCheck 33
  a8)\noBeam c( f e bes des~ |
  des c f~ f16 e bes c es des) |
  r8 c16( des c des es8) es( es |
  es f16 c es des bes4) r8 |
  R2. |

  \barNumberCheck 38
  r4 r8 <ges bes ges'>4( q8 |
  q2.~ |
  q4. q4 q8 |
  q4. <f aes f'>4.) |

  \barNumberCheck 42
  <fes aes fes'>4.( q4 q8 |
  q2.~ |
  q4. q4 q8 |
  q4. << { <es es'>4. } \\ { aes8 bes ces } >> |

  \barNumberCheck 46
  d,8)-.\noBeam d'16( es d es f8) f( f |
  f ges16 f es aes, ces'4.) |
  r8 d,16( es d es f8) f( f |
  f ges16 f es a, c'4.) |

  <<
    \relative c''' {
      \barNumberCheck 50
      \oneVoice bes4.\( \voiceOne
      % EDITORIAL NOTE: Each and every edition contains afterGrace
      \once \override TrillSpanner.outside-staff-priority = ##f
      \once \override TrillSpanner.padding = 2.5
      \afterGrace g4.\startTrillSpan { f16_(\stopTrillSpan g) }
      bes8 aes16 es aes ges ges8 f4\) |
      aes8(-> ges16 des ges f f8 es16 f aes ges |
      a,8)-.\noBeam
    }
    \\
    \relative c'' {
      \barNumberCheck 50
      s4. des |
      des8 c4 es8( des16 aes des c |
      c8 bes4) bes8( c16 des bes c |
      es,8)-.
    }
  >>

  \barNumberCheck 53
  <<
    \relative c'' {
      c16( des c des es4 <bes des>8 |
      q8)-. q16( <c es> <bes des> <c es>
      <bes fes'>4 <bes es>8 |
      q8-.)
    }
    \\
    \relative c'' {
      \temporary \override NoteColumn.force-hshift = -0.6
      ges4~
      \once \override TieColumn.tie-configuration = #'((-2.2 . DOWN))
      ges8
      \revert NoteColumn.force-hshift
      f4 |
      f8-. g4~ g8 ges4 |
      ges8-.
    }
    \\
    \relative c'' {
      \temporary \override NoteColumn.force-hshift = 0.4
      \shape #'((0 . 0)(-0.4 . 0)(-0.8 . 0)(-1.2 . 0)) Tie
      a4_~
      \once \override TieColumn.tie-configuration = #'((-0.5 . DOWN))
      a4
      \revert NoteColumn.force-hshift
    }
  >>

  es,=''16( f es f ges8) ges( ges |
  ges4.~ ^\markup \italic "ten." ges8 f16 c es des |
  bes4. g8) r r |
}

%-------- Left Hand parts
LH = \relative c' {
  \oD r4\p r8 e\> e d |
  d c\! r \absolute{f,16(} c a c d, c') |
  g,( g' <f b> g e g c, g' c a g) r |
  \slurChoice 1 0
  \kneed-beam \once \stemUp \absolute{c,(-.} g c d e8)
  \slurChoice 2 0
  \absolute{f,16(} c a c d, c')
  g,( g' <f b> g e g c, g' c a g) r |
  <<
    \relative c {
      \skip 2. |
      s8. c_~
      \voiceTwo c4
    } \\
    \relative c {
      \oneVoice
      \temporary \override NoteColumn.ignore-collision = ##t
      g16( g' <f b> g e g c, g' c a g c, |
      %% Avoid tie sticking to beam
      \once \override Beam.positions = #'(-4 . -4)
      c' a g c, c' a g4)\fermata
      \revert NoteColumn.ignore-collision
    }
  >>
  r8 | \oneVoice

  \barNumberCheck 8
  \set beatStructure = #'(1 2 1 2)
  r4 r8
      \absolute f,8  -. \ct <c=' f aes>( <aes c f>) |
  \cb \absolute f    -. \ct <des e g>( <bes des e>)
  \cb \absolute f,   -. \ct <c f aes> <aes c f> |
  \cb \absolute f    -. \ct <des e g> <bes des e>
  \cb \absolute f    -. \ct <c f aes> <aes c f> |
  \cb es-.[ <c' aes'> es,-.]
      \absolute es,  -. <g' ees des> <ees des g,> |
      \absolute aes, -. <es c aes>(\< <c aes es>\!
  <f c aes>[\> <es c aes> <c aes es>])\! |

  \barNumberCheck 13
      \absolute aes,,-. \ct <es aes c> <c es aes>
  \cb \absolute aes  -. \ct <fes g bes> <des fes g> |
  \cb \absolute aes, -. \ct <es aes c> <c es aes>
  \cb \absolute aes  -. \ct <fes g bes> <g des bes> |
  \cb \absolute aes, -. \ct <es aes c> <c es aes>
  \cb \absolute es,  -. \ct <es ges bes> <bes es ges> |
  \cb \absolute f,   -. \ct <es f a> <f es a,>
  \cb \absolute bes, -.     <f des bes> <des bes f> |
      \absolute ges, -.     <ges des bes> <des bes ges>
      \absolute des, -.     <f des aes> <des aes f> |

  \barNumberCheck 18
      \absolute es,  -.     <ges c, bes> <es bes ges>
      \absolute f,   -. \ct <a f c> <f c a> |
  \cb \absolute f    -. \ct <g e des> <e des bes>
  \cb \absolute f,   -. \ct <a f c> <f c a> |
  \cb \absolute f    -. \ct <g e des> <e des bes>
  \cb \absolute f,   -. \ct <ges es c> <es bes ges> |
  \cb \absolute f    -. \ct <es ges bes> <ges es c>
  \cb \absolute f,   -. \ct <a es> <f es a,> |
  \cb \absolute bes, -.     <f des bes> <des bes f>
      \absolute c    -.     <e c bes> <c bes g> |

  \barNumberCheck 23
      \absolute f,8  -. \ct <c=' f aes> <aes c f>
  \cb \absolute f    -. \ct <des e g> <bes des e> |
  \cb \absolute f,   -. \ct <c f aes> <aes c f>
  \cb \absolute f    -. \ct <des e g> <bes des e> |
  \cb f-.[ <aes c aes'> fes-.]
      es-.[ <c' aes'> es,-.] |
      \absolute es,  -. <des' g> <des g, es>
      \absolute aes, -. <es c aes>( <c aes es>) |

  \barNumberCheck 27
      \absolute aes, -. <fes c aes>( <c aes fes>)
      \absolute aes,,-. \ct <es aes c> <c es aes> |
  \cb \absolute aes  -. \ct <fes g bes> <des fes g>
  \cb \absolute aes, -. \ct <es aes c> <c es aes> |
  \cb \absolute aes  -. \ct <fes g bes> <g des bes>
  \cb \absolute aes, -. \ct <es aes c> <c es aes> |
  \cb \absolute es,  -. \ct <es ges bes> <bes es ges>
  \cb \absolute f,   -. \ct <es a> <f es a,> |
  \cb \absolute bes, -.     <f des bes> <des bes f>
      \absolute ges, -.     <ges des bes> <des bes ges> |

  \barNumberCheck 32
      \absolute des, -.     <f des aes> <des aes f>
      \absolute es,  -.     <ges c, bes> <es bes ges> |
      \absolute f,   -. \ct <a f c> <f c a>
  % EDITORIAL NOTE: Removing extraneous staccato for 2nd and 3rd note
  \cb \absolute f    -. \ct <g e des> <e des bes> |
  \cb \absolute f,   -. \ct <a f c> <f c a>
  \cb \absolute f    -. \ct <g e des> <e des bes> |
  \cb \absolute f,   -. \ct <ges es c> <es bes ges>
  % LILYPOND BUG: Accidental shown again for G♭ within same measure
  \cb \absolute f    -. \ct <es ges bes> <ges es c> |
  \cb \absolute f,   -. \ct <a es> <f es a,>
  % EDITORIAL NOTE: Dynamics from Cortot and Paderewski makes more sense
  \cb \absolute bes, -.     <f des bes>(_\> <des bes f> |

  \barNumberCheck 37
  \unset beatStructure
  <ges des bes> <f des bes> <des bes f> <bes f des>)\noBeam\!
  <bes, bes,>( <aes aes,> |
  <ges ges,>)\noBeam <des' des,>(_\markup \italic "legato" <ges ges,>
  <bes bes,>         <es   es, >  <bes bes,> |
  <des des,>         <es   es, >  <bes bes,>
  <des des,>         <aes  aes,>  <bes bes,> |
  <ges ges,>)\noBeam <es   es, >( <bes bes,>
  <des des,>         <aes  aes,>  <bes bes,> |
  <ges ges,>)\noBeam <es'' es, >( <bes bes,>
  <des des,>         <aes  aes,>  <bes bes,> |

  \barNumberCheck 42
  <ces ces,>)\noBeam <ces, ces,>( <fes fes,>
  <aes aes,>         <des  des,>  <aes aes,> |
  <ces ces,>         <des  des,>  <aes aes,>
  <ces ces,>         <ges  ges,>  <aes aes,> |
  <fes fes,>)\noBeam <des  des,>( <aes aes,>
  <ces ces,>         <ges  ges,>  <aes aes,> |
  <fes fes,>)\noBeam <des'' des,>( <aes aes,>
  <ces ces,>         <bes  bes,>  <aes aes,> |

  \barNumberCheck 46
  \set beatStructure = #'(1 2 1 2)
  <bes, bes,>)-. <aes' d> <d aes'>
  r <aes d aes'> <f aes d> |
  \absolute ces -. <aes es' aes> <f aes es'>
  \absolute f,  -. <aes es' aes> <f aes es'> |
  \absolute bes,-. <aes d> <d aes'>
  \absolute b,  -. <aes es' aes> <f aes es'> |
  \absolute c   -. <a es' a> <f a es'>
  \absolute f,  -. <a es' a> <f a es'> |
  \absolute bes,-. <bes d aes'> <f bes d>
  \absolute es, -. <bes des g> <des bes es,> |

  \barNumberCheck 51
  \absolute aes,-. <aes es' ges> <c aes es>
  \absolute des,-. <f des aes> <des aes f> |
  \absolute ges,-. <f des bes> <des bes ges>
  \absolute c,  -. <es ges,> r |
  \absolute f,  -. es16( f, es' des c4 bes8 |
  bes8)-. fes'16( f, fes' es des4 c8 |
  c8-.) r r r4 r8 |

  \barNumberCheck 56
  r4 r8
      \absolute f,  -. \ct <es a> <f es a,> |
  \cb \absolute bes,-.     <f des bes> <des bes f>
  \cb \absolute c   -.     <e c bes> <c bes e,> |
}

%-------- Dynamics
Dynamics = {
  \tempo \markup \large "Andante con moto" 4 = 60
  s2.\p |
  \skip 2. |
  \skip 4. s16\< s4 s16\! |
  \crescWithText "poco cresc."
  s2.\< |
  \skip 4.
  \dimWithText "dim e rit."
  s4.\> |
  \skip 2. |
  \skip 4. s4\! \skip 8 |

  \barNumberCheck 8
  \tempo "a tempo"
  <>-\markup "mezza voce"
  \skip 2.*5 |

  \barNumberCheck 13
  s8 s8\mf \skip 2 |
  \skip 2. |
  s8 s2\< s8\! |
  s16*5\> s16\! \skip 4. |
  s8 s2\mp\< s8\! |
  s16*5\> s16\! \skip 4. |

  \barNumberCheck 19
  \skip 2. |
  \skip 2 s4\< |
  \skip 4 s8\! s4.\> |
  \skip 4 s2\! |

  \barNumberCheck 23
  <>-\markup "mezza voce"
  \skip 2.*2 |
  s8 s2\< s8\! |
  s16*5\> s8.\! s4\< |
  s4 s8\! s8 s4\mf |

  \barNumberCheck 28
  \skip 2. |
  s2 s4\< |
  s4 s8\! s16*5\> s16\! |
  \skip 2 s4\mp\< |
  s4 s8\! s16*5\> s16\! |

  \barNumberCheck 33
  s8 s4\p \skip 4. |
  s8 s2\< s16 s16\! |
  s8 s2\< s8\! |
  s16*5\> s16\! \skip 4. |
  % EDITORIAL NOTE: Dynamics from Cortot and Paderewski makes more sense
  \skip 2 s4\dim |
  s2.\pp |
  \skip 2.*5 |

  \barNumberCheck 44
  \skip 4. s4.-\tweak to-barline ##f \< |
  s4.\! s4\> s8\! |
  s8 s2 \< ^\markup \italic "mezza voce" s8\! |
  s16*5\> s16\! \skip 4. |
  s8 s2\< s8\! |
  s16*5\> s16\! \skip 4. |

  \barNumberCheck 50
  s8 s8\cresc \skip 2 |
  \skip 2.*2 |
  s8   s4\< s8\! s4 -\tweak to-barline ##f \> |
  s8\! s4\< s8\! s4 -\tweak to-barline ##f \> |
  s8\! s8 -\tweak to-barline ##f \< \skip 2 |
  s2\! s4\> |
  \skip 4. s4.\! |
}

Pedal = {
  s2\pd s4\pu |
  \skip 4. s\pd s8\pu |
  s8.\pd s16\pu s4\pd s4\pu |
  s4\pd s8\pu s8.\pd s8.\pu |
  \repeat unfold 2 { s8.\pd s16\pu s4\pd s4\pu } |
  \skip 2. |

  \barNumberCheck 8
  \skip 4. \repeat unfold 7 { s4\pd s8\pu } |
  s4.\pd s4.\pu |

  \barNumberCheck 13
  % EDITORIAL NOTE: Follows Padarewski's edition. The pedals are too
  % repetitive and noisy to list. However it's possible this change
  % will need to be reverted in case Piano_pedal_performer is used
  s4. -\tweak X-offset 2.5 -\tweak Y-offset 1
      -\markup { \musicglyph #"pedal.Ped" \italic "simile" }
  \skip 4. |
  \skip 2.*22 |

  \barNumberCheck 36
  s4\pd s8\pu s4\pd s8\pu |
  s8 s4\pd s8\pu s4 |
  s2\pd s8 s8\pu |
  \skip 2.*7 |

  \barNumberCheck 46
  s2\pd s8 s8\pu |
  \repeat unfold 11 { s4\pd s8\pu }
  s8\pd s4\pu |

  \barNumberCheck 53
  s8.\pd s8.\pu \skip 4. |
  \skip 2.*2|
  \skip 4. \repeat unfold 3 { s4\pd s8\pu } |
}

\score {
  \context PianoStaff \with {
    \consists "Piano_pedal_performer"
    connectArpeggios = ##t
    \omit TupletBracket
    \override TupletBracket.avoid-slur = #'ignore
    \override DynamicTextSpanner.style = #'none
    \override DynamicTextSpanner.font-size = 0
    \override NoteCollision.merge-differently-dotted = ##t
  } <<
    \new Staff = "RH" <<
      \key f \minor
      \time 6/8
      \clef treble
      \RH
    >>
    \new Dynamics << \Dynamics >>
    \new Staff = "LH" <<
      \key f \minor
      \time 6/8
      \clef bass
      \LH
    >>
    \new Dynamics \with {
      \override SustainPedal.self-alignment-X = #LEFT
      \override VerticalAxisGroup.staff-affinity = #UP
    } << \Pedal >>
  >>
  \layout {
    \context {
      \Score
      tempoHideNote = ##t
      scriptDefinitions = #my-script-alist
      \override Hairpin.height = 0.5
      \override Script.stencil =  % default accent too large
      #(lambda (grob)
         (let ((script (ly:grob-property grob 'script-stencil)))
           (if (equal? script '(feta . ("sforzato" . "sforzato")))
               (ly:stencil-scale (ly:script-interface::print grob) 0.85 0.85)
               (ly:script-interface::print grob))))
            \override DynamicText.Y-extent =
      #(ly:make-unpure-pure-container ly:grob::stencil-height '(-0 . 0))
      \override Stem.Y-extent = % DIE!!! DIE!!! DIE!!!
      #(ly:make-unpure-pure-container ly:stem::height '(-0 . 0))
      \override Slur.Y-extent =
      #(ly:make-unpure-pure-container ly:slur::height '(-0 . 0))
      \override PhrasingSlur.Y-extent =
      #(ly:make-unpure-pure-container ly:slur::height '(-0 . 0))
    }
  }
  \midi {}
}
