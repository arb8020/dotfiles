# ASD-STE100 Simplified Technical English -- Writing Rules Reference

Issue 9, January 2025. Extracted from Part 1 (Sections 1-9).

---

## How STE Works (General Introduction)

ASD-STE100 Simplified Technical English (STE) is a **controlled natural language** and international standard for technical documentation. It has two parts:

- **Part 1 -- Writing rules** (53 rules in 9 sections): grammar and style constraints
- **Part 2 -- Dictionary** (875 approved words, 1274 not-approved words with alternatives): controlled vocabulary

### Core principles

- Purpose: write technical texts that are clear, simple, unambiguous, and easy to understand for readers worldwide (especially non-native English speakers).
- Each approved word has **one meaning** and is approved as **one part of speech** only. Example: "fall" means only "to move down by the force of gravity," not "to decrease."
- When synonyms exist, STE selects one. Example: STE uses "start" instead of "begin," "commence," "initiate," or "originate."
- Spelling and meanings are based on **American English** (Merriam-Webster).
- Writers may also use **technical nouns** and **technical verbs** specific to their industry (defined in Rules 1.5, 1.12).
- STE does **not** regulate: abbreviations, text formatting, units of measurement.
- STE is not standalone -- use it with applicable specs, style guides, and official directives.
- STE aids machine translation and LLM processing by controlling vocabulary and sentence structure.

### Dictionary principles (Part 2 -- not extracted here)

- UPPERCASE word = approved in STE. lowercase word = not approved.
- Each word has a specified part of speech (n, v, adj, adv, pron, art, prep, conj).
- Not-approved words list approved alternatives with STE and non-STE example sentences.
- Technical nouns are tagged (TN), technical verbs (TV).
- Nouns given in singular; plural of countable nouns is permitted.
- Verbs given with all approved forms (infinitive, 3rd person, past, past participle).
- 875 approved words; 1274 not-approved words with alternatives.

---

## Section 1 -- Words

### Rule 1.1 -- Which words can you use?

> **Use words that are: (a) Approved in the dictionary, (b) Technical nouns, (c) Technical verbs.**

STE has a controlled dictionary of the most frequently used words in technical writing. You can also use words not in the dictionary if they fit the specified categories of technical nouns (Rule 1.5) or technical verbs (Rule 1.12).

- A **technical noun** is a noun term that refers to a specified concept and is applicable to a subject field. Example: "engine."
- A **technical verb** is a verb term that refers to a specified concept or process and is applicable to a subject field. Example: "ream."

**Help:** Technical nouns and technical verbs are usually in your company glossary or terminology database.

---

### Rule 1.2 -- Part of speech

> **Use approved words from the dictionary only as the specified part of speech.**

Each approved word has a specified part of speech. Use it only as that part of speech.

| Situation | Example |
|---|---|
| "Test" is an approved noun, not verb | Non-STE: *Test the system for leaks.* / STE: Do the leak test of the system. |
| "Dim" is an approved adjective, not verb | Non-STE: *Dim the lights.* / STE: Set the lights to the dim position. |
| "Clean" is both verb and adjective | STE (verb): Clean the inner surface. / STE (adj): Make sure that the area is clean. |
| "Acceptable" not approved; alternatives have same POS | Non-STE: *A value of 2 mm is acceptable.* / STE: A value of 2 mm is permitted. |
| "Operable" not approved; alternative has different POS | Non-STE: *Make sure that the valve is operable.* / STE: Make sure that the valve can operate. |

**Help:** If a word you want is not in the dictionary: find it in an English dictionary, find the best approved synonym in STE, use it or find a different sentence construction.

---

### Rule 1.3 -- Approved meaning

> **Use approved words only with their approved meanings.**

Each approved word has a specified approved meaning. Some are more restricted than in standard English.

| Example | Detail |
|---|---|
| "Follow" approved meaning: "come after, go after" | STE: Do the procedures that follow. / STE: Follow the green lights to the nearest staircase. |
| Cannot use "follow" for "obey" | Non-STE: *Follow the safety instructions.* / STE: Obey the safety instructions. |

---

### Rule 1.4 -- Forms of verbs and adjectives

> **Use only the approved forms of verbs and adjectives.**

- **Verbs:** Dictionary gives each verb with its approved forms. Example: REMOVE (v), REMOVES, REMOVED, REMOVED = infinitive/imperative, simple present, simple past, past participle.
- **Adjectives:** Given in base form with comparative and superlative in parentheses where applicable. Example: SLOW (adj) (SLOWER, SLOWEST). Adjectives using "more"/"most" for comparison do not list these forms because "more" and "most" are approved words.

---

### Rule 1.5 -- Technical nouns

> **You can use words that you can include in a technical noun category.**

Technical nouns are not in the dictionary because there are too many and each field uses different ones. You can use them in procedural and descriptive writing if they fit one or more of these **22 categories:**

1. Official parts information (bolt, cable, engine, filter, switch...)
2. Vehicles or machines, and locations on them (aircraft, cockpit, fuselage...)
3. Tools and support equipment, their parts, and locations on them (blade, drill, gauge, jack...)
4. Materials, consumables, and unwanted material (acid, adhesive, fuel, grease, waste...)
5. Facilities, infrastructure, and logistic procedures (airport, hangar, shipping, storage...)
6. Systems, components and circuits, their functions, configurations, and parts (circuit, hardware, pump, vent...)
7. Mathematical, scientific, engineering terms, and formulas (acceleration, diameter, pressure, voltage...)
8. Navigation and geographic terms (altitude, coordinates, heading, north...)
9. Numbers, units of measurement and time (and their symbols) (ampere, hour, meter, second...)
10. Quoted text (texts you cannot change: placards, labels, signs, display units)
11. Professional roles, individuals, groups, organizations, and geopolitical entities (captain, crew, FAA...)
12. Parts of the body (ear, eyes, hand, lung...)
13. Common personal effects, food, and beverages (bread, clothing, coffee...)
14. Medical terms (allergy, diabetes, pulse, virus...)
15. Official documents, parts of documentation, standards, and guidelines (checklist, diagram, manual, revision...)
16. Environmental and operational conditions (humidity, lightning, storm, wind...)
17. Colors (beige, black, green, red, white, yellow... -- colors are adjectives but STE treats them as TN; comparative/superlative forms not permitted)
18. Damage terms (corrosion, crack, dent, erosion, scratch...)
19. Computer science, information and communication technology (AI, backup, database, file, internet, software...)
20. Civil and military operations (bomb, contractor, lifecycle, mission, patrol...)
21. Law and regulations (contract, court, jurisdiction, statute, waiver...)
22. Animals, plants, and other life forms (bacteria, bird, dog, fungi, insect...)

**Help:** The listed examples are not exhaustive. Words have uppercase only when necessary (official identifications, titles, abbreviations).

---

### Rule 1.6 -- Non-approved words as technical nouns

> **Use a word that is not approved in the dictionary, only when it is a technical noun or part of a technical noun.**

If a word is not approved but fits a technical noun category, you can use it as a technical noun in that context.

| Example | Detail |
|---|---|
| "Base" not approved (alternative: "bottom") | Non-STE: *...at the base of the unit.* / STE: ...at the bottom of the unit. But STE: The base of the triangle is 5 cm. ("base" as TN, category 7) |
| "Main" not approved (alternative: "primary") | Non-STE: *The laptop has these main parts.* / STE: The laptop has these primary parts. But STE: Retract the main landing gear. ("main landing gear" is the approved TN) |
| Non-dictionary word as part of TN | STE: ...the relative angular positions... ("relative" not in dictionary but part of TN, category 7) |

---

### Rule 1.7 -- Technical nouns not as verbs

> **Do not use words that are technical nouns as verbs.**

Use a technical noun only as a noun or as an adjective that is part of a different technical noun. Do not use the same word as a verb.

| Example | Detail |
|---|---|
| "Oil" is TN (category 4) | Non-STE: *Oil the steel surfaces.* / STE: Apply oil to the steel surfaces. |
| "Snow" is TN (category 16) | Non-STE: *If you think it will snow...* / STE: If you think that snow will fall... |

Exception: a word can be both a TN (Rule 1.5) and a technical verb (Rule 1.12) if it fits categories of both. Example: "drill" as TN (category 3, a tool) and TV (category 1a, to remove material).

---

### Rule 1.8 -- Use approved technical nouns

> **Use technical nouns that are approved in your company, industry, or subject field.**

If your company/industry has an approved technical noun for a system, component, part, or process, use that technical noun.

---

### Rule 1.9 -- Short technical nouns

> **When you must select a technical noun, use one which is short and easy to understand.**

Select one that is short (not more than three words) and easy to understand. If parts have index numbers and related illustrations clearly identify them, short names suffice.

Non-STE: *Remove the four stainless steel pan head machine screws (10) that attach the metallic machined flange (15) to the front housing cover (20).*
STE: Remove the four screws (10) that attach the flange (15) to the cover (20).

---

### Rule 1.10 -- No regional, slang, or jargon words

> **Do not use regional, slang, or jargon words as technical nouns.**

Always use well-known words. If only a small number of persons understand a word, it will cause confusion.

| Non-STE | STE | Why |
|---|---|---|
| ...attach a *choker* to the heavy machinery... | ...attach a cable to the heavy machinery... | "Choker" is regional (North America/Canada logging term) |
| ...do not *brick* the router. | ...do not set the router to OFF. | "Brick" is IT slang |
| Remove your *gear* from the work area. | Remove your tools and equipment from the work area. | "Gear" is jargon |

---

### Rule 1.11 -- One technical noun per item

> **Do not use different technical nouns for the same item.**

Once you select a technical noun, use it consistently throughout the text.

Non-STE: 1. ...the *servo control unit*... 2. ...the *actuator*... 3. ...the *control unit*...
STE: 1. ...the actuator... 2. ...the actuator... 3. ...the actuator...

---

### Rule 1.12 -- Technical verbs

> **You can use verbs that you can include in a technical verb category.**

Technical verbs must obey the same rules as other approved verbs (Section 3). You can use them if they fit one or more of these **4 categories:**

1. **Manufacturing processes:** (a) Remove material: drill, grind, mill, ream, unsolder. (b) Add material: flame, insulate, remetal, retread. (c) Attach material: braze, crimp, solder, weld. (d) Change mechanical strength/structure/physical properties: anneal, cure, freeze, heat-treat, magnetize, normalize, vaporize. (e) Change surface finish: buff, burnish, dress, passivate, plate, polish. (f) Change shape: blend, cast, extrude, spin, stamp.
2. **Computer processes and applications:** (a) Input/output: click, digitize, enter, press, print, swipe, tap, type. (b) UI/application: clear, close, copy, cut, delete, deselect, disable, drag, drag and drop, enable, encrypt, erase, filter, highlight, invalidate, maximize, minimize, navigate, open, paste, save, scroll, sort, store, tweet, validate, zoom in, zoom out. (c) System operations: abort, boot, communicate, debug, download, format, install, load, manage, process, reboot, update, upgrade, upload.
3. **Instructions and information for applicable subject fields:** (a) Engineering/math/scientific: bisect, compensate for, convert, detect, float, modulate, radiate, transform, sink. (b) Medical: disinfect, intubate, operate, prescribe, sanitize, sterilize. (c) Civil/military: aim, arm, detect, disable, dry-motor, enable, explode, fire, inhibit, intercept, lase, load, lock on, unlatch, unload, wet-motor, parachute. (d) Navigation: approach, descend, deviate, fly, hover, land, maintain, navigate, retrim, take off, trim, respond, taxi. (e) Automotive/railway: accelerate, brake, couple, crank, crash, decouple, dispatch, drift, inflate, park, qualify, steer. (f) Energy/oil/gas: compress, distill, drill, emit, extract, inject, pump.
4. **Law and regulations:** acknowledge, comply with, communicate, conform to, describe, enforce, explain, meet (a requirement), inform, modify, notify, omit, regulate, sign, supersede, understand, waive.

**Key constraints on technical verbs:**
- If an approved verb in the dictionary accurately gives the instruction, use it instead of a TV.
- Use only technical verbs that are correct in your context; do not use general/unclear ones.
- Do not use a TV if it is not necessary; prefer dictionary verbs + applicable TN.

**Help:** The listed examples are not exhaustive.

---

### Rule 1.13 -- Technical verbs not as nouns

> **Do not use technical verbs as nouns.**

Use technical verbs only as verbs, not as nouns. But you can use the past participle form as an adjective.

Non-STE: *Give the hole 0.20-inch ream.* / STE: Ream the hole to a 0.20-inch dimension.
STE: Lubricate the reamed hole. (past participle "reamed" as adjective is OK)

---

### Rule 1.14 -- Spelling

> **Use American English spelling unless other official directives tell you differently.**

Non-STE: *The door is made of carbon fibre reinforced plastic.* ("fibre" is British)
STE: The door is made of carbon-fiber-reinforced plastic.

Non-STE: *Change the colour of the display.* / STE: Change the color of the display.

**Help:** If quoted text has British spelling (e.g., on a screen), keep the quoted text as is. See Rule 8.6.

---

## Section 2 -- Multi-word Nouns

### Rule 2.1 -- Maximum three words

> **Write multi-word nouns of no more than three words.**

Long multi-word nouns are hard to understand. The head noun (usually the last word) gets buried behind modifiers. Keep multi-word nouns to a maximum of three words. Use prepositions to break them up.

| Non-STE | STE |
|---|---|
| *Runway light connection resistance calibration.* (5 words) | Calibration of the resistance of the runway light connection. (1 + 1 + 3 words) |
| *Install the forward turbine overheat thermocouple terminal tags.* (6 words) | Install the terminal tags on the forward overheat thermocouple of the turbine. (2 + 3 words) |
| *Adjust to obtain door operating rod alignment with the attachment point.* (4 words) | Adjust the door operating rod until it aligns with the attachment point. (3 + 1 word) |

---

### Rule 2.2 -- Long technical nouns

> **When a technical noun has more than three words, write it in full. Then, you can use one of these methods to make it clear: (a) Give a shorter form of the technical noun. (b) Use hyphens (-) between words that you use as one unit.**

**Method 1 -- Shorter form:** Write the full TN the first time, then explain and use a shorter form or approved abbreviation in subsequent text. Example: "ramp service door safety connector pin" -> first use in full with explanation, then "safety connector pin" (3 words).

**Method 2 -- Hyphens:** Use hyphens between related words that operate as one unit. Hyphenated words count as one word. Examples: cutoff-switch power connection (3 words), lavatory rapid-decompression device (3 words).

Do not use hyphens to make groups of more than three words. Do not hyphenate approved TNs of three words or less. If an approved TN includes a hyphen (e.g., "inward-outward valve"), keep it.

---

## Section 3 -- Verbs

### Rule 3.1 -- Approved verb forms

> **Use only the verb forms that are given in the dictionary.**

The dictionary gives the verb forms you can use for each approved verb.

**Help:** The introduction to the dictionary in Part 2 gives more information about verb forms.

---

### Rule 3.2 -- Permitted verb forms and tenses

> **Use only these verb forms and tenses of verbs: (a) The infinitive form, (b) The imperative form (command form), (c) The simple present tense, (d) The simple past tense, (e) The simple future tense, (f) The past participle form (as an adjective).**

| Form | Example (regular: adjust) | Example (irregular: give) |
|---|---|---|
| Infinitive | (To) Adjust | (To) Give |
| Imperative | Adjust + object | Give + object |
| Simple present | adjusts / adjust | gives / give |
| Simple past | adjusted | gave |
| Simple future | will adjust | will give |
| Past participle (adj) | The adjusted linkage | The given information |

**Do NOT use:** present perfect (have/has adjusted), past perfect (had adjusted), present/past progressive (is/was adjusting), or any other complex verb constructions.

---

### Rule 3.3 -- Past participle as adjective

> **Use the past participle form as an adjective.**

Use it before a noun or after "to be," "to become," "to stay." It shows condition, not passive voice.

STE: Examine all parts of the disassembled unit for damage.
STE: When the unit is fully disassembled, clean all the parts.

Do not use the past participle form if it is not in the dictionary. Some approved adjectives are past participle forms of non-approved verbs (e.g., "permitted," "damaged") -- their approved POS is (adj).

---

### Rule 3.4 -- No complex verb constructions

> **Do not use auxiliary verbs to make complex verb constructions.**

Do not combine past participle with "have" (present perfect) or other auxiliaries that create passive constructions.

| Non-STE | STE |
|---|---|
| *The operator has adjusted the linkage.* | The operator adjusted the linkage. |
| *The seat is to be installed before you install the cushion.* | Before you install the cushion, install the seat. |
| *The volume control can be adjusted.* | You can adjust the volume control. |
| *The temperature must be adjusted.* | Adjust the temperature. |
| *The sleeve will be adjusted by the robot.* | The robot will adjust the sleeve. |

---

### Rule 3.5 -- The "-ing" form

> **Use the "-ing" form of a verb only as a technical noun or as a modifier in a technical noun.**

Words with "-ing" can serve many functions (verb part, adjective, noun, modifier) causing ambiguity. They are usually not permitted in STE.

**Permitted uses:**
- As a technical noun (in titles/headings): Cleaning, Testing and Fault Isolation, Handling, Packaging, Shipping, Troubleshooting
- As a modifier in a technical noun: air-conditioning system, grinding wheel, polishing disc, sanding machine, switching relay, welding torch

**Approved "-ing" words in the dictionary:** Nouns (lighting, opening, routing, servicing), Adjectives (mating, missing, remaining), Pronoun (something), Preposition (during).

| Non-STE | STE |
|---|---|
| *When you are doing this procedure, obey all the safety precautions.* | When you do this procedure, obey all the safety precautions. |

---

### Rule 3.6 -- Active voice

> **Use the active voice. In descriptive writing, you can use the passive voice only when the agent is unknown.**

Always use active voice. Passive voice is permitted in descriptive writing **only** when the agent (person/thing doing the action) is unknown.

**How to detect passive:** Think "by whom or by what?" If the sentence answers this, it is passive.

**Four methods to convert passive to active:**
1. Move the agent ("by" object) to subject position: *The circuits are connected by a switching relay.* -> A switching relay connects the circuits.
2. Change infinitive to active verb: *These values are used by the computer to calculate...* -> The computer calculates...
3. Use imperative (procedural writing): *The test can be continued by the operator.* -> Continue the test.
4. Use "you" or "we" as subject: *On the ground, the valve can be opened with the override handle.* -> On the ground, you can open the valve with the override handle.

**When passive is acceptable (descriptive only, agent unknown):**
- *During transmission, the data was corrupted.* (correct -- agent unknown)
- You can also use "something" as the agent to make it active.

---

### Rule 3.7 -- Describe actions with verbs

> **Use an approved verb to describe an action, not a noun or other parts of speech.**

Verbs describe actions more clearly than nouns.

| Do not write | Write |
|---|---|
| The ohmmeter *gives an indication of* 450 ohms. | The ohmmeter shows 450 ohms. |
| Before *the removal* of the unit... | Before you remove the unit... |
| *Check* the laptop battery. ("check" not approved as verb) | Do a check of the laptop battery. |

---

## Section 4 -- Sentences

### Rule 4.1 -- Short and clear sentences

> **Write short and clear sentences.**

- **Procedures:** Give short and clear instructions directly to the reader (imperative form).
- **Descriptive text:** Each sentence has only one topic (subject or idea), no imperative form. Gradually give information about that topic.
- **Both types:** Be accurate. Do not give information that is not accurate or can have different meanings.

| Non-STE | STE |
|---|---|
| *No leaks are permitted.* | Make sure that there are no leaks. |
| *Different temperatures will change the cure time.* | When the temperature increases, the cure time will decrease. |

---

### Rule 4.2 -- Do not omit words or use contractions

> **Do not omit words or use contractions to make your sentences shorter.**

Do not omit nouns, verbs, subjects, or articles. Do not use contractions (don't, isn't, aren't).

| Non-STE | STE | What was omitted |
|---|---|---|
| *Can be a maximum of five inches long.* | Cracks can have a maximum length of five inches. | Noun (subject) |
| *Rotary switch to INPUT.* | Set the rotary switch to INPUT. | Verb |
| *If installed, remove the shims.* | If shims are installed, remove them. | Subject |
| *Remove the bolt and stop.* | Remove the bolt and the stop. | Article |
| *...don't touch the USB power adapter.* | ...do not touch the USB power adapter. | Contraction |

---

### Rule 4.3 -- Vertical lists

> **Use a vertical list for complex texts.**

When a sentence is long and includes many items or actions, use a vertical list.

**Formatting rules:**
- Put a colon (:) at the end of the introductory sentence
- Identify each item with a dash, bullet, letter, or number
- Start each item with an uppercase letter
- Use an article before the noun that is the subject of each item (where applicable)
- Period at the end of full-sentence items; no period for non-full-sentence items
- No commas or semicolons at end of items
- Period at the end of the last item
- Do not mix procedural and descriptive writing in the same list

**Help:** Which marks/symbols to use -- refer to applicable specs and style guides.

In safety instructions within vertical lists, include negative commands (DO NOT) for each item separately.

---

### Rule 4.4 -- Connecting words and phrases

> **Use connecting words and connecting phrases to connect sentences that contain related topics.**

Connecting words (and, but, then, thus) and phrases (as a result, at the same time) give logical structure and tell the reader how information relates.

- In **descriptive text:** use freely for logical structure.
- In **procedures:** use when explanation is needed after a work step, or in safety instructions.

You can also use demonstrative adjectives (this, these) as connecting words.

---

### Rule 4.5 -- Articles and demonstrative adjectives

> **When applicable, use an article (the, a, an) or a demonstrative adjective (this, these) before a noun or a multi-word noun.**

Do not omit articles to make text shorter. Use correctly:
- No article before general statements or abstract concepts: "Solvents can cause damage to paint."
- In short sentences, article before all nouns can be clearer: "Install the nuts (2) and the bolts (3)."
- In long series, article only before the first noun: "Discard the O-rings (3), gaskets (4), seals (7), and washers (9)."
- No definite article before a noun with an alphanumeric identifier (it is a proper noun): *Incorrect: Tag the circuit breaker 36L7.* / CORRECT: Tag circuit breaker 36L7.

**Help:** Refer to a grammar reference (e.g., "Practical English Usage" by Swan) for article usage.

---

## Section 5 -- Procedural Writing

### Rule 5.1 -- Sentence length in procedures

> **Write short sentences. Use a maximum of 20 words in each sentence.**

The maximum length for procedural sentences is **20 words**. Warnings, cautions, and other safety instructions must also obey this rule.

**Help:** Notes (Rule 5.5) do not obey Rule 5.1 -- the maximum for a note sentence is **25 words** (they contain information only).

---

### Rule 5.2 -- One instruction per sentence

> **Write only one instruction in each sentence unless two or more actions occur at the same time.**

One instruction per sentence. Clearly show sequence with numbers or letters.

**Exception:** You can combine instructions when actions occur simultaneously or a result occurs immediately after an action.

STE: Hold the panel in its open position and install the fastener.
STE: Cut and remove the wire.

---

### Rule 5.3 -- Imperative form

> **Write instructions in the imperative (command) form.**

STE: Set the switch to ON. / Remove the four bolts. / Install the new O-ring.

Do not use "must" before the imperative unless the instruction is critical for safety or an important condition.

Non-STE: *Before you remove the clamp, you must disconnect the hose.*
STE: Before you remove the clamp, disconnect the hose.

STE: WARNING: IF YOU MUST CUT THE WIRE, ALWAYS USE A PROTECTIVE MASK. (safety context -- "must" OK)

---

### Rule 5.4 -- Conditions first

> **When there is a condition that the reader must know about first, start the instruction with a descriptive statement. Then, divide that descriptive statement from the command with a comma.**

Write the condition first, then comma, then the command.

| Do not write | Write |
|---|---|
| *Set the switch to NORMAL when the light comes on.* | When the light comes on, set the switch to NORMAL. |
| *Apply the primer when the surface is dry.* | When the surface is dry, apply the primer. |

**The comma is important.** Its position can change meaning:
- "If the CSD does not operate correctly, disconnect it from the gearbox." ("correctly" modifies "operate")
- "If the CSD does not operate, correctly disconnect it from the gearbox." ("correctly" modifies "disconnect")

---

### Rule 5.5 -- Notes

> **Write notes only to give information, not instructions.**

Notes give information to help the reader during a procedure. They contain descriptive text and obey descriptive writing rules. Maximum sentence length in a note: **25 words**.

**Do not:**
- Use imperative form in a note (it becomes a work step, not a note)
- Give instructions, requirements, or limits in notes
- Give limits/tolerances/results of work steps in notes (put them directly in the work step)

**Test for correct note usage:** Read the procedure without the notes. If the reader can still do the procedure correctly, the notes are used correctly. If important info is missing, move it from the note into a work step.

**Help:** Notes are for procedures. In descriptions, use notes only for illustrations or tables.

---

## Section 6 -- Descriptive Writing

### Rule 6.1 -- Give information gradually

> **Give information gradually.**

Each sentence should contain only one subject. Do not give too much information too quickly.

---

### Rule 6.2 -- Key words and key phrases

> **Use key words and key phrases to give your text a logical structure.**

Key words recur in a text to connect ideas. Key phrases have the same function. When you use them, do not change them -- consistent terminology keeps text clear.

Also use connecting words (and, but, then, thus) and connecting phrases (as a result, at the same time) as "traffic signs" to show the reader how information connects.

---

### Rule 6.3 -- Sentence length in descriptions

> **Write short sentences. Use a maximum of 25 words in each sentence.**

Descriptive text maximum sentence length: **25 words** (longer than procedural because descriptive text is more complex).

---

### Rule 6.4 -- Paragraphs show related information

> **Use paragraphs to show related information.**

Start each paragraph with a **topic sentence** that tells the reader the topic. Following sentences explain or add information about that topic. The topic sentence gives new information and connects logically to previous information via key words and/or connecting words.

---

### Rule 6.5 -- One topic per paragraph

> **Make sure that each paragraph has only one topic.**

The topic sentence is the first and most important sentence. If the reader writes down all topic sentences, they get a good outline of the text.

---

### Rule 6.6 -- Maximum six sentences per paragraph

> **Make sure that no paragraph has more than six sentences.**

If a paragraph has more than six sentences, divide it into two smaller paragraphs.

---

## Section 7 -- Safety Instructions

### Definitions

- **Warning:** tells the reader there is a risk of **injury or death**.
- **Caution:** tells the reader there is a risk of **damage to objects**.

**Help:** Other industries may use different words (danger, attention, notice) or graphical symbols. Ensure content obeys Rules 7.1-7.3 regardless.

If both levels of risk are present, use a "warning."

---

### Rule 7.1 -- Identify risk level

> **Use an applicable word (for example, "warning" or "caution") to identify the level of risk.**

Use a word or symbol to immediately show the level of risk.

**Help:** All examples in Section 7 are uppercase, but STE does not give formatting rules. Refer to applicable specs and style guides.

Examples:
- WARNING: BEFORE YOU FILL THE LIQUID OXYGEN SYSTEM, PUT ON A FACE MASK AND PROTECTIVE CLOTHING. LIQUID OXYGEN CAN CAUSE IRRITATION...
- CAUTION: DO NOT USE BLEACH OR CLEANSERS THAT CONTAIN CHLORINE TO CLEAN THE UNIT. THESE CLEANING AGENTS CAN CAUSE CORROSION.

---

### Rule 7.2 -- Clear command or condition first

> **Start a safety instruction with a clear and accurate command or condition.**

Start with the command (what to do/not do) or, if a condition applies, the condition first.

Examples with command first:
- WARNING: DO NOT SWALLOW THE SOLVENT. ALWAYS MAKE SURE THAT YOU KNOW THE SAFETY PRECAUTIONS...

Examples with condition first:
- WARNING: WHILE YOU USE THE SPRAY PAINT, POINT THE SPRAY AWAY FROM YOUR FACE.
- CAUTION: WHEN YOU ASSEMBLE THE UNIT, DO NOT LET THE PARTS FALL.

---

### Rule 7.3 -- Explain the risk

> **Give an explanation to show the risk or possible result.**

Always tell the reader what can happen if they do not obey the safety instruction.

- WARNING: ...SOLVENTS ARE POISONOUS AND CAN CAUSE INJURY OR DEATH.
- CAUTION: ...THESE CLEANING AGENTS CAN CAUSE CORROSION.
- WARNING: ...THE SPRAY PAINT CAN CAUSE INJURY TO YOUR EYES.
- CAUTION: ...IF THEY FALL, PERMANENT DAMAGE TO THE PARTS CAN OCCUR.

---

## Section 8 -- Punctuation and Word Count

### Rule 8.1 -- No semicolons

> **You can use all standard English punctuation marks but not the semicolon (;).**

The semicolon lets you write very long sentences and is hard to use correctly. Always write two separate sentences instead.

Non-STE: *Examine the removed parts; replace the damaged ones.*
STE: (1) Examine the removed parts for damage. (2) Replace the damaged part(s).

---

### Rule 8.2 -- Hyphens

> **Use hyphens (-) to connect words that are directly related.**

Use hyphens for:
1. Multi-word adjectives before a noun: low-altitude flight, high-pressure chamber, air-conditioned compartment, fire-resistant material, self-sealing hose
2. Two-word fractions or numbers: forty-seven, ninety-ninth, one thirty-second
3. Uppercase letter/number + noun (shape/configuration): L-shaped bracket, O-ring, T-shirt, U-beam, V-band clamp, 3-prong connector
4. Verbs with noun/different POS as first part: die-cast, arc-weld, fusion-bond, heat-treat, jump-start, short-circuit, dry-clean
5. Prefix ending in vowel + root starting with vowel: pre-amplifier, de-icing, anti-icing, pre-engage

**Help:** A hyphen is different from a dash (which divides ideas, shows ranges, or signals a pause).

---

### Rule 8.3 -- Parentheses

> **You can use parentheses to: (1) Make references to illustrations or text, (2) Include identifying letters/numbers, (3) Identify work steps, (4) Include abbreviations, (5) Give singular and plural forms, (6) Explain words or part of a sentence, (7) Include an alternative.**

Examples:
- Remove the valve (10, Figure 1).
- Disconnect the hoses (2) and (12) from the suction ejector (8).
- A Liquid Crystal Display (LCD) is...
- Before you do the test(s), install the component(s).
- Increase the pressure slowly (not more than 10 psi each minute).
- Open the left (right) access panel L42 (R42).

---

### Rule 8.4 -- Colon in vertical lists

> **In a vertical list, a colon (:) has the same effect on word count as a period and shows the end of a sentence.**

The colon divides the introductory sentence from the list items. Word count limits apply:
- **Before the colon:** max 20 words (procedural) or 25 words (descriptive)
- **Each list item** counts as a new sentence with same limits

---

### Rule 8.5 -- Text in parentheses

> **When you put text in parentheses, it counts as one word in that sentence.**

The parenthetical text also constitutes a separate sentence for word-count purposes. Identifiers (numbers, letters, alphanumeric) in parentheses count as one word.

---

### Rule 8.6 -- Elements that count as one word

> **Count each of these elements as one word: Numbers, Numbers together with units of measurement, Abbreviations, Alphanumeric identifiers, Quoted text, Titles/headings/placards/labels, Proper nouns of individuals/groups/organizations/geopolitical entities.**

Key examples:
- "10 degrees C" or "10 Celsius" = 1 word (number + unit)
- "NASA" = 1 word
- "36L7" = 1 word
- "SHORT-CIRCUIT TEST" (quoted text on equipment) = 1 word
- "C = (A - B) - 0.063 mm" (formula, quoted text) = 1 word
- "Structural Repair Manual" (document title) = 1 word
- "United States of America" (geopolitical entity) = 1 word
- "George Washington" (individual) = 1 word

**Help:** Do not count numbers that identify paragraphs or work steps (they are part of document numbering).

---

### Rule 8.7 -- Hyphenated words

> **Hyphenated words count as one word.**

Examples: soap-and-water solution (7 words total), cutoff-switch power connection (3 words), main-gear-door retraction-winch handle (3 words).

---

## Section 9 -- Writing Practices

### Rule 9.1 -- Different sentence constructions

> **Use a different sentence construction to write a sentence when a word-for-word replacement is not sufficient.**

A different sentence construction is necessary when:
1. **You must change grammatical structure** to use the alternative. Non-STE: *The oil level on the sight gauge must be visible during the test.* / STE: During the test, make sure that you can see the oil level on the sight gauge.
2. **Word-for-word replacement gives a meaningless result.** Non-STE: *...the service life of the unit can be uncertain.* / STE: ...it is possible that the service life of this unit will be shorter than usual.
3. **The approved alternative changes the meaning.** Non-STE: *Just apply very light pressure...* / STE: Only apply very light pressure... (NOT: *Immediately apply...* which changes meaning)
4. **The word to replace is not in the dictionary at all.** Non-STE: *The incidence of water in fuel is dangerous.* / STE: Water in fuel is dangerous.

**Key technique:** Ask "What is the meaning?" and "What action must the reader do?" then write a new sentence with approved words.

---

### Rule 9.2 -- Use approved words correctly

> **Use each approved word correctly.**

Approved words have restricted meanings. Always check the dictionary definition.

| Non-STE | STE | Why |
|---|---|---|
| *Wear protective clothing.* | Use (or put on) protective clothing. | "Wear" approved meaning: "to become damaged by friction" |
| *This regulation extends to all units.* | This regulation is applicable to all units. | "Extend" means "to increase in dimension/range" |
| *When the pressure goes down, lift the cover.* | When the pressure decreases, lift the cover. | "Go down" is for physical movement of indicators |
| *Move the tube to see if the connection is tight.* | Move the tube to make sure that the connection is tight. | "See" is only for visual observation |
| *The indicator turns green.* | The color of the indicator changes to green. | "Turn" is only for physical rotation |
| *Do not let the pressure go below 20 psi.* | Do not let the pressure become less than 20 psi. | "Above"/"below" are for physical positions only |
| *When you work with cleaning agents...* | When you do work with cleaning agents... | "Work" approved as noun, not verb |
| *Install the cover with the help of a second person.* | Install the cover with the aid of a second person. | "Help" approved as verb, not noun |
| *Be careful not to damage the sleeve.* | Be careful not to cause damage to the sleeve. | "Damage" approved as noun, not verb |

---

### Rule 9.3 -- No phrasal verbs

> **When you use two words together, do not make phrasal verbs.**

A phrasal verb (verb + preposition) has a meaning different from its parts. Do not combine approved words to create new phrasal meanings.

| Non-STE | STE |
|---|---|
| After you *put out* the fire, close the valve... | After you extinguish the fire, close the valve... |
| This compound can *give off* poisonous fumes. | This compound can release poisonous fumes. |

Only a small number of phrasal verbs are approved (e.g., "put on," "come on") -- they have restricted meaning.

---

### Rule 9.4 -- Consistent style

> **When you select terminology or wording, always use a consistent style.**

When you select a sentence style for a type of work step, use the same style consistently throughout. Do not use different terms for the same item or different sentence patterns for the same action.

Non-STE (inconsistent): Steps alternate between "Lubricate the two bolts with oil" and "Apply oil to the threads of the bolts" for the same type of action.
STE: Pick one style and use it every time.

---

## General Recommendations (GR)

These are **not rules** but recommendations to prevent common errors.

### GR-1 -- The conjunction "that"

Use "that" to connect a subordinate clause to a main clause (after verbs like "make sure," "show," "recommend"). Native speakers often omit it, but including it prevents ambiguity and aids translation.

| Do not write | Write |
|---|---|
| *Make sure the valve is open.* | Make sure **that** the valve is open. |
| *The gauge shows the reservoir is full.* | The gauge shows **that** the reservoir is full. |

---

### GR-2 -- The preposition "with"

"With" has three approved meanings in STE: association/relationship, help/sharing, means/instrument. It can cause ambiguity. Example: "Install the panel with the green fasteners" could mean three things.

| Do not write | Write |
|---|---|
| *Lift the aircraft at the maximum takeoff weight with passengers.* | Lift the aircraft at the maximum takeoff weight (passenger weight included). |
| *Use tool TS9867 to seal the opening.* | Seal the opening with tool TS9867. (Show the primary action verb) |

---

### GR-3 -- How to use pronouns

Approved pronouns are in the dictionary. Do not use pronouns not in the dictionary (e.g., "she," "he"). If a pronoun can refer to more than one noun (ambiguity), replace it with the specific word.

| Do not write | Write |
|---|---|
| *If you engage the pins incorrectly with the seats, they can become damaged.* | ...the pins can become damaged. (or "the seats" or "the pins and seats") |

---

### GR-4 -- The pronoun "this"

Make sure the reader knows what "this" refers to. If it can refer to more than one item, give context.

| Do not write | Write |
|---|---|
| *Make sure that the cover is not locked (this can cause damage to the probe).* | Make sure that the cover is not locked. If the cover is locked, this can cause damage to the probe. |

---

### GR-5 -- False friends

A false friend is a word that looks the same in the writer's native language but has a different meaning in English. When you use a word, make sure it has the correct meaning in English.

Do not write: *Obey the dispositions of the manufacturer...*
Write: When you use this adhesive, obey the manufacturer's instructions.

---

### GR-6 -- Latin abbreviations

Do not use Latin abbreviations (e.g., i.e., etc.). Use English words instead.

| Do not write | Write |
|---|---|
| *Discard the standard parts (e.g., washers, screws...)* | Discard the standard parts (for example, washers, bolts, and nuts)... |
| *...different colors (blue, green, red, etc.).* | ...different colors. They can be blue, green, red, or other colors. |

---

### GR-7 -- Inclusive language

Use gender-neutral language. Gender-specific pronouns ("he," "she") are not permitted in STE. The words "man" and "woman" are also not permitted unless necessary in context (e.g., medical text). STE uses neutral terms and constructions to prevent gender bias.

---

### GR-8 -- Possessive form

The possessive form (apostrophe + "s") is permitted in STE but use it correctly. If you are not sure, do not use it. Non-native readers may find it difficult because other languages handle possession differently.

---

## Quick Reference: Sentence Length Limits

| Context | Maximum words |
|---|---|
| Procedural sentence | 20 |
| Note sentence (in a procedure) | 25 |
| Descriptive sentence | 25 |
| Paragraph | 6 sentences max |
| Multi-word noun | 3 words max |

## Quick Reference: All 53 Rules by Number

| Rule | Section | Statement |
|---|---|---|
| 1.1 | Words | Use words that are approved, technical nouns, or technical verbs |
| 1.2 | Words | Use approved words only as the specified part of speech |
| 1.3 | Words | Use approved words only with their approved meanings |
| 1.4 | Words | Use only the approved forms of verbs and adjectives |
| 1.5 | Words | You can use words in a technical noun category (22 categories) |
| 1.6 | Words | Use non-approved words only as technical nouns or parts of them |
| 1.7 | Words | Do not use technical nouns as verbs |
| 1.8 | Words | Use technical nouns approved in your company/industry/field |
| 1.9 | Words | Select short (max 3 words), easy-to-understand technical nouns |
| 1.10 | Words | No regional, slang, or jargon words as technical nouns |
| 1.11 | Words | Do not use different technical nouns for the same item |
| 1.12 | Words | You can use verbs in a technical verb category (4 categories) |
| 1.13 | Words | Do not use technical verbs as nouns |
| 1.14 | Words | Use American English spelling |
| 2.1 | Multi-word nouns | Max 3 words per multi-word noun |
| 2.2 | Multi-word nouns | Long TNs: write in full, then use shorter form or hyphens |
| 3.1 | Verbs | Use only dictionary verb forms |
| 3.2 | Verbs | Only 6 permitted verb forms/tenses |
| 3.3 | Verbs | Past participle as adjective only |
| 3.4 | Verbs | No complex verb constructions with auxiliaries |
| 3.5 | Verbs | "-ing" form only as TN or modifier in TN |
| 3.6 | Verbs | Active voice; passive only in descriptive when agent unknown |
| 3.7 | Verbs | Use verbs (not nouns) to describe actions |
| 4.1 | Sentences | Write short and clear sentences |
| 4.2 | Sentences | Do not omit words or use contractions |
| 4.3 | Sentences | Use vertical lists for complex texts |
| 4.4 | Sentences | Use connecting words/phrases for related topics |
| 4.5 | Sentences | Use articles/demonstrative adjectives before nouns |
| 5.1 | Procedural | Max 20 words per sentence |
| 5.2 | Procedural | One instruction per sentence (unless simultaneous) |
| 5.3 | Procedural | Use imperative form |
| 5.4 | Procedural | Condition first, then comma, then command |
| 5.5 | Procedural | Notes give information only, not instructions |
| 6.1 | Descriptive | Give information gradually |
| 6.2 | Descriptive | Use key words/phrases for logical structure |
| 6.3 | Descriptive | Max 25 words per sentence |
| 6.4 | Descriptive | Use paragraphs for related information |
| 6.5 | Descriptive | One topic per paragraph |
| 6.6 | Descriptive | Max 6 sentences per paragraph |
| 7.1 | Safety | Identify risk level (warning/caution) |
| 7.2 | Safety | Start with clear command or condition |
| 7.3 | Safety | Explain the risk or possible result |
| 8.1 | Punctuation | All punctuation marks except semicolon |
| 8.2 | Punctuation | Hyphens connect directly related words |
| 8.3 | Punctuation | Parentheses for 7 specified uses |
| 8.4 | Word count | Colon in vertical list = end of sentence for word count |
| 8.5 | Word count | Text in parentheses = 1 word |
| 8.6 | Word count | Numbers, abbreviations, quoted text, titles, proper nouns = 1 word each |
| 8.7 | Word count | Hyphenated words = 1 word |
| 9.1 | Practices | Use different sentence construction when word-for-word replacement fails |
| 9.2 | Practices | Use each approved word correctly (restricted meanings) |
| 9.3 | Practices | Do not make phrasal verbs from approved words |
| 9.4 | Practices | Use consistent terminology and wording style |
