# LoRA-Training-Batch-Converter
use this script to create a batch file for multiple LoRA trainings with Kohya

~ You can train different LoRA's overnight or when you are AFK. Or you can test changing specific settings.

**Files**
convert_LoRA_training_command.vbs
  This is the main script file. It creates the other files you will be working with.

LoRA_training_command.txt
  Running convert_LoRA_training_command.vbs the first time creates this file
  You copy-paste LoRA training commands into this file, seperated by a file line feeds / pressing enter

Lora_training_batch.bat
  After the LoRA_training_command.txt has training commands in it, run convert_LoRA_training_command.vbs and it will create this batch file


**Instructions**


1. Download the Repo

2. Leave the script file "convert_LoRA_training_command.vbs" in the folder "LoRA_Training_Batches,"
or you can rename the folder, or put it in another folder.
~ But I recommend that this script and the files it creates stay together in the same folder to prevent errors and to stay tidy

3. Edit the script file "convert_LoRA_training_command.vbs" with Notepad or another text editor
~ Look for this line:
  kohyaPath = "D:\AI_Stuff\Stable Diffusion\Kohya\kohya_ss"
~ change it to the FULL PATH of the folder where you have Kohya installed.
  For example, if yo have Kohya installed here:
  C:\EXAMPLE_FOLDER\kohya_ss
  Then change the line to this:
  kohyaPath = "C:\EXAMPLE_FOLDER\kohya_ss"

~ then save the script file and close it

4. Now run the script file "convert_LoRA_training_command.vbs"
~ It shows a message about how it created a text file, LoRA_training_command.txt

5. In Kohya, setup your training, but don't run it. Instead, click the button at the bottom, "Print training command"

6. Copy the command that appears on the console, it starts with "accelerate launch" and has all your training parameters.
Here is an example:

accelerate launch --num_cpu_threads_per_process=2 "./train_network.py" --pretrained_model_name_or_path="runwayml/stable-diffusion-v1-5" --train_data_dir="D:\AI_Stuff\Stable Diffusion\Training\celebrities\Jeri Ryan\birme-768x768" --reg_data_dir="D:\AI_Stuff\Stable Diffusion\Training\stable-diffusion-Regularization-Images-main\sd2.1\woman-training-folder" --resolution="768,768" --output_dir="D:\AI_Stuff\Stable Diffusion\Training\celebrities\Jeri Ryan\Lora - 768" --logging_dir="D:\AI_Stuff\Stable Diffusion\Training\celebrities\Jeri Ryan\Lora - 768\log" --network_alpha="128" --training_comment="keywords: JeriRy@n" --save_model_as=safetensors --network_module=networks.lora --network_dim=128 --gradient_accumulation_steps=3 --output_name="JeriRy@n_768-768_GAS_3" --lr_scheduler_num_cycles="1" --no_half_vae --learning_rate="0.0001" --lr_scheduler="constant" --train_batch_size="3" --max_train_steps="347" --mixed_precision="bf16" --save_precision="bf16" --seed="1234" --caption_extension=".txt" --cache_latents --cache_latents_to_disk --optimizer_type="AdamW8bit" --max_data_loader_n_workers="1" --clip_skip=2 --bucket_reso_steps=1 --mem_eff_attn --gradient_checkpointing --xformers --bucket_no_upscale --multires_noise_iterations="8" --multires_noise_discount="0.2" --sample_sampler=euler_a --sample_prompts="D:\AI_Stuff\Stable Diffusion\Training\celebrities\Jeri Ryan\Lora - 768\sample\prompt.txt" --sample_every_n_epochs="1" --sample_every_n_steps="50"

7. Paste that training command into the text file "LoRA_training_command.txt"

8. Then press enter a couple of times to give space for the next training, and save the file with Ctrl+S.

9. Repeat steps 5-8 for all of the trainings you do.
  _NOTE:_
~ Make sure you setup each training so that the "Model output name" in the folders tab is different, and there is something different about each training.

10. After pasting all of the training commands, make sure the file is saved with Ctrl+S and close it

11. Run the script file "convert_LoRA_training_command.vbs" again, and it creates the batch file "Lora_training_batch.bat"

12. When you are ready, run the batch file "Lora_training_batch.bat"
  _NOTE:_
~ Make sure Stable Diffusion Automatic1111 is NOT RUNNING, and nothing else that uses the GPU is running BEFORE running this batch file

13. Checking on the batch file / monitoring progress
~ The title bar of the command window will show you which training is in progress, with numbers in the X of Y format.
  Example. I have a batch running with two trainings, and it shows this:
  [1 of 2] JeriRy@n_768-768_GAS_3

~ The normal statuses of Kohya trainings are shown in the batch file as they normally would in a Kohya console




