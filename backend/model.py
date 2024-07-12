import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torchvision import datasets, transforms
from torch.optim.lr_scheduler import StepLR
import timm
import numpy as np

class SwinModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.swin_cl = timm.create_model('swin_base_patch4_window7_224_in22k', pretrained=True, num_classes=0, global_pool='')
        self.swin_cb = timm.create_model('swin_base_patch4_window7_224_in22k', pretrained=True, num_classes=0, global_pool='')

        self.linear_cl = nn.Sequential(nn.Linear(1024, 1024),
                                       nn.ReLU(),
                                       nn.Linear(1024, 1024))
        self.linear_cb = nn.Linear(1024, 1024)

    def freeze_layer():
        for param in self.swin_cl.parameters():
            param.requires_grad = False

    def get_embeddings(self, image, ftype):
        linear = self.linear_cl if ftype == "contactless" else self.linear_cl
        swin   = self.swin_cl   if ftype == "contactless" else self.swin_cb

        tokens = swin(image)
        emb_mean = tokens.mean(dim=1)
        feat = linear(emb_mean)
        tokens = linear(tokens)
        return feat, tokens

    def forward(self, x_cl, x_cb):
        x_cl_tokens = self.swin_cl(x_cl)
        x_cl_mean = x_cl_tokens.mean(dim=1)
        x_cl = self.linear_cl(x_cl_mean)
        x_cl_tokens = self.linear_cl(x_cl_tokens)

        x_cb_tokens = self.swin_cb(x_cb)
        x_cb_mean = x_cb_tokens.mean(dim=1)
        x_cb = self.linear_cl(x_cb_mean)
        x_cb_tokens = self.linear_cl(x_cb_tokens)

        return x_cl, x_cb, x_cl_tokens, x_cb_tokens